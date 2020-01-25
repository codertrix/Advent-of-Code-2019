// ---------------------------------------------------
//  main.swift
//  Day24
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

let input = """
###..
#...#
.#.##
##.#.
#.###
"""


// --------------------
//   MARK: - Puzzle 1
// --------------------

func biodiversity(for eris: [[Character]]) -> Int {
    var bd = 0
    for (index, character) in eris.joined().enumerated() {
        if character == "#" { bd += Int(pow(2.0, Double(index))) }
    }

    return bd
}

func neighbors(for x: Int, _ y: Int) -> [(x: Int, y: Int)] {
    [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]
        .filter { $0.x >= 0 && $0.x < 5 && $0.y >= 0 && $0.y < 5 }
}

var eris = input.split(separator: "\n").map { $0.utf8.map { Character(UnicodeScalar($0)) } }
var biodiversities = [biodiversity(for: eris)]

while true {
    var newEris = [[Character]]()
    for (y, row) in eris.enumerated() {
        newEris.append([])
        for (x, character) in row.enumerated() {
            var bugs = 0
            for neighbor in neighbors(for: x, y) {
                if eris[neighbor.y][neighbor.x] == "#" { bugs += 1 }
            }

            if bugs == 1 || (character == "." && bugs == 2) {
                newEris[y].append("#")
            } else {
                newEris[y].append(".")
            }
        }
    }

    let biodiv = biodiversity(for: newEris)
    if biodiversities.contains(biodiv) {
        print("Puzzle 1: The biodiversity rating is \(biodiv)")
        break
    }

    biodiversities.append(biodiv)
    eris = newEris
    newEris = []
}


// --------------------
//   MARK: - Puzzle 2
// --------------------

func rcrsNeighbors(for level: Int, _ x: Int, _ y: Int, levelCount: Int) -> [(level: Int, x: Int, y: Int)] {
    var indexes: [(level: Int, x: Int, y: Int)] = [(level, x - 1, y), (level, x + 1, y), (level, x, y - 1), (level, x, y + 1)]
        .filter { $0.x >= 0 && $0.y >= 0 && $0.x < 5 && $0.y < 5 && !($0.x == 2 && $0.y == 2) }

    if level > 0 {
        if y == 0 { indexes.append((level: level - 1, x: 2, y: 1)) }
        if y == 4 { indexes.append((level: level - 1, x: 2, y: 3)) }
        if x == 0 { indexes.append((level: level - 1, x: 1, y: 2)) }
        if x == 4 { indexes.append((level: level - 1, x: 3, y: 2)) }
    }

    if level < levelCount - 1 {
        switch (x, y) {
            case (2, 1): for xx in 0...4 { indexes.append((level: level + 1, x: xx, y: 0)) }
            case (2, 3): for xx in 0...4 { indexes.append((level: level + 1, x: xx, y: 4)) }
            case (1, 2): for yy in 0...4 { indexes.append((level: level + 1, x: 0, y: yy)) }
            case (3, 2): for yy in 0...4 { indexes.append((level: level + 1, x: 4, y: yy)) }
            default: break
        }
    }

    return indexes
}

var level0 = input.split(separator: "\n").map { $0.utf8.map { Character(UnicodeScalar($0)) } }
level0[2][2] = "?"
let levelN: [[Character]] = [
    [".", ".", ".", ".", "."],
    [".", ".", ".", ".", "."],
    [".", ".", "?", ".", "."],
    [".", ".", ".", ".", "."],
    [".", ".", ".", ".", "."]
]
var rcrsEris = [levelN, level0, levelN]

for _ in 1...200 {
    var newRcrsEris = Array(repeating: levelN, count: rcrsEris.count)

    for (level, eris) in rcrsEris.enumerated() {
        for (y, row) in eris.enumerated() {
            for (x, character) in row.enumerated() {
                if x == 2 && y == 2 { continue }
                var bugs = 0
                for neighbor in rcrsNeighbors(for: level, x, y, levelCount: newRcrsEris.count) {
                    if rcrsEris[neighbor.level][neighbor.y][neighbor.x] == "#" { bugs += 1 }
                }

                if bugs == 1 || (character == "." && bugs == 2) {
                    newRcrsEris[level][y][x] = "#"
                }
            }
        }
    }

    if newRcrsEris[0].joined().contains("#") { newRcrsEris.insert(levelN, at: 0) }
    if newRcrsEris.last!.joined().contains("#") { newRcrsEris.append(levelN) }

    rcrsEris = newRcrsEris
}

let bugsTotal = rcrsEris.reduce(0) {
    var bugsCount = 0
    $1.joined().forEach {
        bugsCount += $0 == "#" ? 1 : 0
    }
    return $0 + bugsCount
}

print("Puzzle 2: The total number of bugs is \(bugsTotal)")
