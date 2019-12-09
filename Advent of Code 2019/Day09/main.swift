// ---------------------------------------------------
//  main.swift
//  Day09
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

struct Intcode {
    var pc: Int = 0
    var relativeBase = 0
    var program: [Int]
    var isHalted = false
    var input = [Int]()
    var output: Int = 0

    init(program: [Int]) {
        self.program = program + Array(repeating: 0, count: 2000)
    }

    mutating func run(withInput: Int) {
        input.append(withInput)

        while true {
            let opcode = program[pc] % 100
            let mode1 = program[pc] / 100 % 10
            let mode2 = program[pc] / 1000 % 10
            let mode3 = program[pc] / 10000 % 10

            if opcode == 99 {
                isHalted = true
                return
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

            let value1 = program[idx[0]]
            let value2 = [3, 4, 9].contains(opcode) ? 0 : program[idx[1]]
            pc += [3, 4, 9].contains(opcode) ? -1 : 1

            switch opcode {
                case 1: program[idx[2]] = value1 + value2
                case 2: program[idx[2]] = value1 * value2
                case 3: if input.isEmpty { return }; program[idx[0]] = input.removeFirst()
                case 4: print(value1)
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

var computer = Intcode(program: input)

print("Puzzle 1: The BOOST keycode is ", terminator: "")
computer.run(withInput: 1)


// --------------------
//   MARK: - Puzzle 2
// --------------------

computer = Intcode(program: input)

print("The coordinates of the distress signal are ", terminator: "")
computer.run(withInput: 2)
