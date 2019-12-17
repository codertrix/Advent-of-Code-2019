// ---------------------------------------------------
//  main.swift
//  Day13
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

let Block = 2
let Paddle = 3
let Ball = 4


// --------------------
//   MARK: - Puzzle 1
// --------------------

var maxX = 0
var maxY = 0
var tilesCount = 0
var program = Intcode(program: input, input: { 0 })

while true {
    guard let x = program.run() else { break }
    guard let y = program.run() else { break }
    guard let t = program.run() else { break }

    maxX = max(maxX, x)
    maxY = max(maxY, y)
    if t == Block { tilesCount += 1 }
}

print("Puzzle 1: The number of block tiles is \(tilesCount)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

var screen = Array(repeating: Array(repeating: 0, count: maxX + 1), count: maxY + 1)
var score = 0
var joystick = 0
var xPaddle = 0
var xBall = 0
var game = input

game[0] = 2
program = Intcode(program: game, input: { joystick })

while true {
    guard let x = program.run() else { break }
    guard let y = program.run() else { break }
    guard let t = program.run() else { break }

    if x == -1 {
        score = t
    } else {
        screen[y][x] = t
        if t == Paddle { xPaddle = x }
        if t == Ball { xBall = x }
    }

    let dx = xBall - xPaddle
    joystick = dx == 0 ? 0 : dx / abs(dx)
}

print("Puzzle 2: The score is \(score)")
