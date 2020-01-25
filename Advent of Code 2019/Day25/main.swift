// ---------------------------------------------------
//  main.swift
//  Day25
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

var output = ""
var command = """
south
west
take fuel cell
west
take easter egg
east
east
north
north
north
east
east
take cake
west
west
south
south
east
take ornament
east
take hologram
east
take dark matter
north
north
east
take klein bottle
north
take hypercube
north\n
"""
var program = Intcode(program: input) {
    guard let value = command.removeFirst().asciiValue else { fatalError() }
    return Int(value)

}

let items = ["ornament", "easter egg", "hypercube", "hologram", "cake", "fuel cell", "dark matter", "klein bottle"]
items.forEach { command += "drop " + $0 + "\n" }

for i in 0...255 {
    var itemSet = [String]()
    for j in 0...7 {
        if i >> j & 1 == 1 { itemSet.append(items[j]) }
    }
    itemSet.forEach { command += "take " + $0 + "\n" }
    command += "west\n"
    itemSet.forEach { command += "drop " + $0 + "\n" }
}

while true {
    guard let value = program.run() else { break }

    if let c = UnicodeScalar(value) {
        let cc = Character(c)
        output.append(cc)
        print(cc, terminator: "")
    }

    if output.contains("Command?") {
        print(" ", terminator: "")
        output = ""
        while command.isEmpty {
            guard let line = readLine(strippingNewline: false) else { continue }
            command = line
            break
        }
    }

    if command.hasPrefix("stop") { break }
}
