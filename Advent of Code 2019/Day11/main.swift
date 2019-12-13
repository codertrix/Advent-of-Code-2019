// ---------------------------------------------------
//  main.swift
//  Day11
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

enum Heading: Int {
    case up, down, left, right

    func turn(direction: Int) -> Heading {
        let d = direction == 0
        switch self {
            case .up: return d ? .left : .right
            case .down: return d ? .right : .left
            case .left: return d ? .down : .up
            case .right: return d ? .up : .down
        }
    }
}

struct Panel: Hashable {
    let x: Int
    let y: Int
}

struct Intcode {
    var pc: Int = 0
    var relativeBase = 0
    var program: [Int]
    var isHalted = false
    var input: () -> Int

    init(program: [Int], input: @escaping () -> Int) {
        self.program = program + Array(repeating: 0, count: 2000)
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

let dx = [0, 0, -1, 1]
let dy = [-1, 1, 0, 0]

var x = 0
var y = 0
var heading = Heading.up
var panels = [Panel: Int]()

let panelColor: () -> Int = { panels[Panel(x: x, y: y)] ?? 0 }
var robot = Intcode(program: input, input: panelColor)

while true {
    guard let color = robot.run() else { break }
    guard let direction = robot.run() else { break }

    panels[Panel(x: x, y: y)] = color
    heading = heading.turn(direction: direction)

    x += dx[heading.rawValue]
    y += dy[heading.rawValue]
}

print("Puzzle1: The number of painted panels is \(panels.keys.count)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

x = 0
y = 0
heading = .up
panels = [Panel(x: x, y: y): 1]
robot = Intcode(program: input, input: panelColor)

while true {
    guard let color = robot.run() else { break }
    guard let direction = robot.run() else { break }

    panels[Panel(x: x, y: y)] = color
    heading = heading.turn(direction: direction)

    x += dx[heading.rawValue]
    y += dy[heading.rawValue]
}

let (minX, _) = panels.min { $0.key.x < $1.key.x }!
let (maxX, _) = panels.max { $0.key.x < $1.key.x }!
let (minY, _) = panels.min { $0.key.y < $1.key.y }!
let (maxY, _) = panels.max { $0.key.y < $1.key.y }!

let columns = maxX.x - minX.x + 1
let rows = maxY.y - minY.y + 1
var registration = Array(repeating: Array(repeating: " ", count: columns), count: rows)

panels.forEach { registration[$0.key.y][$0.key.x] = $0.value == 1 ? "*" : " " }

print("Puzzle2:")
registration.forEach { (row) in
    row.forEach { (column) in
        print(column, terminator: "")
    }
    print()
}
