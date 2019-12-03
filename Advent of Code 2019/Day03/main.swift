// ---------------------------------------------------
//  main.swift
//  Day03
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

struct Position: Hashable {
    let x: Int
    let y: Int
}

func move(x: inout Int, y: inout Int, direction: String) {
    switch direction {
        case "R": x += 1
        case "L": x -= 1
        case "D": y += 1
        case "U": y -= 1
        default: break
    }
}

let lines = input.split(separator: "\n")
let path1 = lines[0].split(separator: ",")
let path2 = lines[1].split(separator: ",")

var positions = [Position: Int]()
var intersections = [Position: Int]()

var x = 0
var y = 0
var steps = 0

for var turn in path1 {
    if let direction = turn.popFirst() {
        let value = Int(turn)!

        for _ in 0..<value {
            move(x: &x, y: &y, direction: String(direction))
            steps += 1
            positions[Position(x: x, y: y)] = steps
        }
    }
}

x = 0
y = 0
steps = 0

for var turn in path2 {
    if let direction = turn.popFirst() {
        let value = Int(turn)!

        for _ in 0..<value {
            move(x: &x, y: &y, direction: String(direction))
            steps += 1
            let position = Position(x: x, y: y)
            if positions.contains(where: { (pos, _) -> Bool in pos == position }) {
                intersections[position] = steps
            }
        }
    }
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

let distance = intersections.reduce(Int.max) { min($0, abs($1.key.x) + abs($1.key.y)) }

print("Puzzle 1: The Manhattan distance from the central port to the closest intersection is \(distance)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

let fewestSteps = intersections.reduce(Int.max) {  min($0, positions[$1.key]! + $1.value) }

print("Puzzle 2: The fewest combined steps the wires must take to reach an intersection are \(fewestSteps)")
