// ---------------------------------------------------
//  main.swift
//  Day15
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

    @discardableResult
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

struct Position: Comparable, Equatable, Hashable {
    static func < (lhs: Position, rhs: Position) -> Bool { lhs.d < rhs.d }
    static func == (lhs: Position, rhs: Position) -> Bool { lhs.x == rhs.x && lhs.y == rhs.y }

    let x, y, d, type: Int

    init(_ x: Int, _ y: Int, _ d: Int = Int.max, type: Int = 0) {
        self.x = x
        self.y = y
        self.d = d
        self.type = type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

let delta: [(x: Int, y: Int)] = [(0, 0), (0, -1), (0, 1), (-1, 0), (1, 0)]


// ------------------------
//   MARK: - Puzzle 1 + 2
// ------------------------

var x = 0
var y = 0
var command = 0
var program = Intcode(program: input, input: { command })

var stack = [Position(x, y, 0, type: 3)]
var seen = Set<Position>()
var moves = [(direction: Int, x: Int, y: Int)]()
var branches = [Int]()
var lastDistance = 0

while !stack.isEmpty {
    let position = stack.removeLast()

    if seen.contains(position) { continue }
    seen.insert(position)

    repeat {
        switch (position.x - x, position.y - y) {
            case (0, -1): command = 1
            case (0, 1): command = 2
            case (-1, 0): command = 3
            case (1, 0): command = 4
            default:
                if branches.count > 0 {
                    var lastSteps = lastDistance - branches.removeLast()
                    while lastSteps > 0 && lastSteps <= moves.count {
                        let move = moves.removeLast()
                        command = move.direction - 1 ^ 1 + 1
                        program.run()
                        x += delta[command].x
                        y += delta[command].y
                        lastSteps -= 1
                    }
                    command = 0
            }
        }
    } while command == 0 && lastDistance > 0

    if command > 0 {
        x = position.x
        y = position.y
        moves.append((command, x, y))
        program.run()
    }

    if position.type == 2 {
        print("Puzzle 1: The fewest number of movement commands is \(position.d)")
        stack = [Position(position.x, position.y, 0, type: 1)]
        seen.removeAll()
        moves = []
        branches = []
        lastDistance = 0
        continue
    }

    var possibleDirections = 0

    for direction in 1...4 {
        let xx = position.x + delta[direction].x
        let yy = position.y + delta[direction].y
        command = direction
        let status = program.run()!

        if status > 0 {
            if !seen.contains(Position(xx, yy)) {
                stack.append(Position(xx, yy, position.d + 1, type: status))
                possibleDirections += 1
            }
            command = direction - 1 ^ 1 + 1
            program.run()
        } else {
            seen.insert(Position(xx, yy))
        }
    }

    if possibleDirections > 1 { branches.append(position.d)}
    lastDistance = position.d
}

print("Puzzle 2: It takes \(seen.filter { $0.type == 1 }.max()!.d) minutes")
