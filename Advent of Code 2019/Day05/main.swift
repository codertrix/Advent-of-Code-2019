// ---------------------------------------------------
//  main.swift
//  Day05
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

func run(program: [Int], inputValue: Int) -> Int {
    var memory = program
    var result = 0
    var pc = 0

    while true {
        let opcode = memory[pc] % 100
        var value1 = 0
        var value2 = 0

        if opcode != 3 && opcode != 4 && opcode != 99 {
            value1 = memory[pc] % 1000 / 100 == 1 ? memory[pc + 1] : memory[memory[pc + 1]]
            value2 = memory[pc] / 1000 == 1 ? memory[pc + 2] : memory[memory[pc + 2]]
        }

        switch opcode {
            case 1:
                memory[memory[pc + 3]] = value1 + value2
                pc += 4
            case 2:
                memory[memory[pc + 3]] = value1 * value2
                pc += 4
            case 3:
                memory[memory[pc + 1]] = inputValue
                pc += 2
            case 4:
                result = memory[memory[pc + 1]]
                pc += 2
            case 5:
                pc = value1 != 0 ? value2 : pc + 3
            case 6:
                pc = value1 == 0 ? value2 : pc + 3
            case 7:
                memory[memory[pc + 3]] = value1 < value2 ? 1 : 0
                pc += 4
            case 8:
                memory[memory[pc + 3]] = value1 == value2 ? 1 : 0
                pc += 4
            case 99:
                return result
            default:
                break
        }
    }
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

print("Puzzle 1: The diagnostic code is \(run(program: input, inputValue: 1))")


// --------------------
//   MARK: - Puzzle 2
// --------------------

print("Puzzle 2: The diagnostic code is \(run(program: input, inputValue: 5))")
