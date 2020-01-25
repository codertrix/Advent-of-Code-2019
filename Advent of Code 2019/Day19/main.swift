// ---------------------------------------------------
//  main.swift
//  Day19
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
                case 3: program[idx[0]] = input();
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


// --------------------
//   MARK: - Puzzle 1
// --------------------

var programInput = [Int]()
var affected = 0

for y in 0..<50 {
    for x in 0..<50 {
        programInput = [x, y]
        var program = Intcode(program: input) { programInput.removeFirst() }
        affected += program.run()!
    }
}

print("Puzzle 1: \(affected) points are affected by the tractor beam")


// --------------------
//   MARK: - Puzzle 2
// --------------------

var x = 100
var y = 100
var minX = -1
var minY = 0
var program = Intcode(program: input) { programInput.removeFirst() }
affected = 0

func query(x: Int, y: Int) -> Int {
    programInput = [x, y]
    program = Intcode(program: input) { programInput.removeFirst() }

    guard let result = program.run() else { fatalError() }

    return result
}

while minX == 0 || minY == 0 {
    x = minX
    while affected == 0 {
        x += 1
        affected = query(x: x, y: y)
    }

    affected = query(x: x + 99, y: y)

    if affected == 1 {
        minX = x
        affected = query(x: x, y: y + 99)
        if affected == 1 { minY = y }
    } else {
        y += 1
    }
}

print("Puzzle 2: The value is \(minX * 10000 + minY)")
