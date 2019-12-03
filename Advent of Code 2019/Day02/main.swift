// ---------------------------------------------------
//  main.swift
//  Day02
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

func run(program: [Int], noun: Int, verb: Int) -> Int {
    var memory = program
    memory[1] = noun
    memory[2] = verb

    var pc = 0
    var opcode = input[pc]

    while opcode != 99 {
        let idx1 = memory[pc + 1]
        let idx2 = memory[pc + 2]
        let idx3 = memory[pc + 3]

        switch opcode {
            case 1:
                memory[idx3] = memory[idx1] + memory[idx2]
            case 2:
                memory[idx3] = memory[idx1] * memory[idx2]
            default:
                break
        }

        pc += 4
        opcode = memory[pc]
    }

    return memory[0]
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var result = run(program: input, noun: 12, verb: 2)
print("Puzzle 1: The value at position 0 is \(result)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

func nounVerbFor(result: Int) -> Int {
    for noun in 0...99 {
        for verb in 0...99 {
            if result == run(program: input, noun: noun, verb: verb) {
                return noun * 100 + verb
            }
        }
    }
    return -1
}

result = nounVerbFor(result: 19690720)
if result >= 0 {
    print("Puzzle2: The answer is \(result)")
}
