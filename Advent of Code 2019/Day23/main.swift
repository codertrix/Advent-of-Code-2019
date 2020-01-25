// ---------------------------------------------------
//  main.swift
//  Day23
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

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
                        if program[idx[0]] == -1 { return nil }
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

var computers = [Intcode]()
var inputQueues = [[Int]]()

func initializeComputers() {
    computers = [Intcode]()
    inputQueues = [[Int]]()

    for address in 0...49 {
        inputQueues.append([address])
        computers.append(Intcode(program: input, input: {
            if inputQueues[address].isEmpty { return -1 }
            return inputQueues[address].removeFirst()
        }))
        _ = computers[address].run()
    }
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

initializeComputers()

Loop1:
while true {
    for address in 0...49 {
        if let destination = computers[address].run(), let x = computers[address].run(), let y = computers[address].run() {
            if destination == 255 {
                print("Puzzle 1: The Y value of the first packet sent to address 255 is \(y)")
                break Loop1
            }

            inputQueues[destination] += [x, y]
        }
    }
}


// --------------------
//   MARK: - Puzzle 2
// --------------------

var natX = 0
var natY = 0
var lastYSend = -1
var idleComputers = Set<Int>()

initializeComputers()

Loop2:
while true {
    for address in 0...49 {
        if let destination = computers[address].run(), let x = computers[address].run(), let y = computers[address].run() {
            if destination == 255 {
                natX = x
                natY = y
            } else {
                inputQueues[destination] += [x, y]
            }
        } else {
            idleComputers.insert(address)

            if idleComputers.count == 50 {
                inputQueues[0] += [natX, natY]
                if lastYSend == natY {
                    print("Puzzle 2: The first Y value delivered twice in a row is \(natY)")
                    break Loop2
                }
                lastYSend = natY
                idleComputers = []
            }
        }
    }
}
