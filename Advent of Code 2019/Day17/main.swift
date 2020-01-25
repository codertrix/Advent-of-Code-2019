// ---------------------------------------------------
//  main.swift
//  Day17
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

var view = [[Character]]()
var line = [Character]()
var program = Intcode(program: input, input: { 0 })

while true {
    guard let a = program.run() else { break }

    if a == 10 && !line.isEmpty {
        view.append(line)
        line = []
    } else {
        line.append(Character(UnicodeScalar(a)!))
    }
}

let rows = view.count
let columns = view[0].count
var robot = (0, 0)


// --------------------
//   MARK: - Puzzle 1
// --------------------

func isIntersection(in view: [[Character]], at x: Int, _ y: Int) -> Bool {
    if view[y][x] != "#" { return false }
    if view[y - 1][x] == "#" && view[y + 1][x] == "#" && view[y][x - 1] == "#" && view[y][x + 1] == "#" {
        return true
    }

    return false
}

var sumOfAlignmentParameters = 0

for y in 1..<rows - 2 {
    for x in 1..<columns - 2 {
        if isIntersection(in: view, at: x, y) {
            sumOfAlignmentParameters += x * y
        }
        if ["^", "v", "<", ">"].contains(view[y][x]) {
            robot = (x, y)
        }
    }
}

print("Puzzle 1: The sum of the alignment parameters is \(sumOfAlignmentParameters)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

var x = robot.0
var y = robot.1

func shouldTurn(in view: [[Character]], at x: Int, _ y: Int, withHeading: inout Character) -> Character? {
    switch withHeading {
        case "^":
            if y > 0 && view[y - 1][x] == "#" { return nil }
            if x > 0 && view[y][x - 1] == "#" { withHeading = "<"; return "L" }
            if x < columns - 1 && view[y][x + 1] == "#" { withHeading = ">"; return "R" }
        case "v":
            if y < rows - 1 && view[y + 1][x] == "#" { return nil }
            if x > 0 && view[y][x - 1] == "#" { withHeading = "<"; return "R" }
            if x < columns - 1 && view[y][x + 1] == "#" { withHeading = ">"; return "L" }
        case "<":
            if x > 0 && view[y][x - 1] == "#" { return nil }
            if y > 0 && view[y - 1][x] == "#" { withHeading = "^"; return "R" }
            if y < rows - 1 && view[y + 1][x] == "#" { withHeading = "v"; return "L" }
        case ">":
            if x < columns - 1 && view[y][x + 1] == "#" { return nil }
            if y > 0 && view[y - 1][x] == "#" { withHeading = "^"; return "L" }
            if y < rows - 1 && view[y + 1][x] == "#" { withHeading = "v"; return "R" }
        default:
            fatalError()
    }

    return "."
}

var stepCount = 0
var heading = view[robot.1][robot.0]
var moves = ""

while true {
    if let c = shouldTurn(in: view, at: x, y, withHeading: &heading) {
        if c == "." {
            moves.append("\(stepCount)")
            break
        }

        if stepCount > 0 { moves.append("\(stepCount),") }
        moves.append("\(c)")
        stepCount = 0
    } else {
        stepCount += 1
        switch heading {
            case "^": y -= 1
            case "v": y += 1
            case "<": x -= 1
            case ">": x += 1
            default: fatalError()
        }
    }
}

// print(moves)
// I used the 'moves' string to find the movement functions manually.
//
//   R12,L10,L10,L6,L12,R12,L4,R12,L10,L10,L6,L12,R12,L4,L12,R12,L6,L6,L12,R12,L4,L12,R12,L6,R12,L10,L10,L12,R12,L6,L12,R12,L6
// A R12,L10,L10               R12,L10,L10                                                   R12,L10,L10
// B             L6,L12,R12,L4             L6,L12,R12,L4            L6,L12,R12,L4
// C                                                     L12,R12,L6               L12,R12,L6             L12,R12,L6 L12,R12,L6
//   A           B             A           B             C          B             C          A           C          C

let mainMovement = "A,B,A,B,C,B,C,A,C,C\n"
let movementA = "R,12,L,10,L,10\n"
let movementB = "L,6,L,12,R,12,L,4\n"
let movementC = "L,12,R,12,L,6\n"

var programInput = mainMovement + movementA + movementB + movementC + "n\n"
var code = input
code[0] = 2

program = Intcode(program: code) { () -> Int in
    guard let value = programInput.removeFirst().asciiValue else { fatalError() }
    return Int(value)
}

var collectedDust = 0

while true {
    guard let result = program.run() else { break }
    collectedDust = result
}

print("Puzzle 2: The amount of collected dust is \(collectedDust)")
