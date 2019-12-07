// ---------------------------------------------------
//  main.swift
//  Day07
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

struct Amplifier {
    var pc: Int = 0
    var program: [Int]
    var isHalted = false
    var input = [Int]()
    var output: Int = 0

    init(program: [Int], phase: Int) {
        self.program = program
        input.append(phase)
    }

    mutating func run(withInput: Int) {
        input.append(withInput)

        while true {
            let opcode = program[pc] % 100
            var value1 = 0
            var value2 = 0

            if opcode != 3 && opcode != 4 && opcode != 99 {
                value1 = program[pc] % 1000 / 100 == 1 ? program[pc + 1] : program[program[pc + 1]]
                value2 = program[pc] / 1000 == 1 ? program[pc + 2] : program[program[pc + 2]]
            }

            switch opcode {
                case 1:
                    program[program[pc + 3]] = value1 + value2
                    pc += 4
                case 2:
                    program[program[pc + 3]] = value1 * value2
                    pc += 4
                case 3:
                    if input.isEmpty { return }
                    program[program[pc + 1]] = input.removeFirst()
                    pc += 2
                case 4:
                    output = program[pc] % 1000 / 100 == 1 ? program[pc + 1] : program[program[pc + 1]]
                    pc += 2
                case 5:
                    pc = value1 != 0 ? value2 : pc + 3
                case 6:
                    pc = value1 == 0 ? value2 : pc + 3
                case 7:
                    program[program[pc + 3]] = value1 < value2 ? 1 : 0
                    pc += 4
                case 8:
                    program[program[pc + 3]] = value1 == value2 ? 1 : 0
                    pc += 4
                case 99:
                    isHalted = true
                    return
                default:
                    break
            }
        }
    }
}

func sequences(s: [Int]) -> [[Int]] {
    var s = s
    var sequences = [[Int]]()

    func permute(s: inout [Int], startIndex: Int, endIndex: Int) {
        if startIndex == endIndex {
            sequences.append(s)
        } else {
            for index in startIndex...endIndex {
                s.swapAt(startIndex, index)
                permute(s: &s, startIndex: startIndex + 1, endIndex: endIndex)
                s.swapAt(startIndex, index)
            }
        }
    }

    permute(s: &s, startIndex: 0, endIndex: s.count - 1)

    return sequences
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var maxSignal = 0

for sequence in sequences(s: [0, 1, 2, 3, 4]) {
    var signal = 0

    for amp in 0...4 {
        var amplifier = Amplifier(program: input, phase: sequence[amp])
        amplifier.run(withInput: signal)
        signal = amplifier.output
    }

    maxSignal = max(maxSignal, signal)
}

print("Puzzle 1: The highest signal is \(maxSignal)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

for sequence in sequences(s: [5, 6, 7, 8, 9]) {
    var amplifier = [Amplifier]()
    var signal = 0

    for amp in 0...4 { amplifier.append(Amplifier(program: input, phase: sequence[amp])) }

    var amp = 0
    while true {
        amplifier[amp].run(withInput: signal)
        signal = amplifier[amp].output
        if amp == 4 && amplifier[amp].isHalted { break }
        amp = (amp + 1) % 5
    }

    maxSignal = max(maxSignal, signal)
}

print("Puzzle 2: The highest signal is \(maxSignal)")
