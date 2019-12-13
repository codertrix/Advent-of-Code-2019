// ---------------------------------------------------
//  main.swift
//  Day10
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

let map = input.split(separator: "\n").map({ $0.map({ $0 == "." ? false : true }) })
let rows = map.count
let columns = map[0].count

struct Location: Hashable {
    let x: Int
    let y: Int
}

func ggt(_ a: Int, _ b: Int) -> Int {
    if a == 0 { return abs(b) }
    return ggt(b % a, a)
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var detectedAsteroids = Set<Location>()
var bestLocation = Location(x: 0, y: 0)


for y in 0..<rows {
    for x in 0..<columns {
        if !map[y][x] { continue }

        var asteroids = Set<Location>()
        for yy in 0..<rows {
            for xx in 0..<columns {
                if map[yy][xx] && (xx != x || yy != y) {
                    let dx = xx - x
                    let dy = yy - y
                    var gt = ggt(dx, dy)
                    if gt == 0 { gt = 1 }
                    asteroids.insert(Location(x: dx / gt, y: dy / gt))
                }
            }
        }

        if detectedAsteroids.count < asteroids.count {
            detectedAsteroids = asteroids
            bestLocation = Location(x: x, y: y)
        }
   }
}

print("Puzzle 1: Number of detected asteroids from he best location (x: \(bestLocation.x), y: \(bestLocation.y)) is \(detectedAsteroids.count)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

var angles = [Location: Double]()

detectedAsteroids.forEach { (location) in
    let x = Double(location.x)
    let y = Double(location.y)
    let angle = acos(-y / sqrt(x * x + y * y))

    angles[location] = x < 0 ? 2 * Double.pi - angle : angle
}

let sortedAngles = angles.sorted { $0.value < $1.value }
let asteroid200 = sortedAngles[199].key
let result = (asteroid200.x + bestLocation.x) * 100 + asteroid200.y + bestLocation.y

print("Puzzle 2: The result for the 200th asteroid is \(result)")
