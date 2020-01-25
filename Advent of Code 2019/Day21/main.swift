// ---------------------------------------------------
//  main.swift
//  Day21
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

struct Intcode {
    var pc: Int = 0
    var relativeBase = 0
    var program: [Int]
    var isHalted = false
    var input: () -> Int

    init(program: [Int], input: @escaping () -> Int) {
        self.program = program
        self.input = input
    }

    mutating func run() -> Int? {
        while true {
            let opcode = program[pc] % 100
            let mode1 = program[pc] / 100 % 10
            let mode2 = program[pc] / 1000 % 10
            let mode3 = program[pc] / 10000 % 10

            if opcode == 99 {
                isHalted = true
                return nil
            }

            var idx = [Int]()
            for mode in [mode1, mode2, mode3] {
                if pc + 1 < program.count { pc += 1 }
                switch mode {
                    case 0: idx.append(program[pc])
                    case 1: idx.append(pc)
                    case 2: idx.append(program[pc] + relativeBase)
                    default: fatalError()
                }
            }

            let maxIdx = idx.max()!
            if maxIdx >= program.count {
                program += Array(repeating: 0, count: maxIdx - program.count + 1)
            }

            let value1 = program[idx[0]]
            let value2 = [3, 4, 9].contains(opcode) ? 0 : program[idx[1]]
            pc += [3, 4, 9].contains(opcode) ? -1 : 1

            switch opcode {
                case 1: program[idx[2]] = value1 + value2
                case 2: program[idx[2]] = value1 * value2
                case 3: program[idx[0]] = input()
                case 4: return value1
                case 5: pc = value1 != 0 ? value2 : pc - 1
                case 6: pc = value1 == 0 ? value2 : pc - 1
                case 7: program[idx[2]] = value1 < value2 ? 1 : 0
                case 8: program[idx[2]] = value1 == value2 ? 1 : 0
                case 9: relativeBase += program[idx[0]]
                default: fatalError()
            }
        }
    }
}

func runProgram(_ intcode: [Int], with script: String, debug: Bool = false) -> Int {
    var springScript = script
    var program = Intcode(program: intcode) {
        guard let value = springScript.removeFirst().asciiValue else { fatalError() }
        return Int(value)
    }
    var result = -1

    while true {
        guard let output = program.run() else { break }
        if debug && output < 128 {
            print(Character(UnicodeScalar(output)!), terminator: "")
        } else {
            result = output
        }
    }

    return result
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var springScript = """
NOT A J
AND D J
NOT B T
AND D T
OR T J
NOT C T
AND D T
OR T J
WALK\n
"""

print("Puzzle 1: The amount of hull damage is \(runProgram(input, with: springScript))")


// --------------------
//   MARK: - Puzzle 2
// --------------------

springScript = """
NOT A J
AND D J
NOT B T
AND D T
OR T J
NOT C T
AND D T
OR T J
NOT E T
NOT T T
OR H T
AND T J
RUN\n
"""

print("Puzzle 2: The amount of hull damage is \(runProgram(input, with: springScript))")
