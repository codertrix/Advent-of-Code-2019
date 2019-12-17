// ---------------------------------------------------
//  main.swift
//  Day12
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation


// --------------------
//   MARK: - Puzzle 1
// --------------------

struct Moon: Hashable {
    var x, y, z: Int
    var vx = 0
    var vy = 0
    var vz = 0

    var potentialEnergy: Int { abs(x) + abs(y) + abs(z) }
    var kineticEnergy: Int { abs(vx) + abs(vy) + abs(vz) }
    var totalEnergy: Int { potentialEnergy * kineticEnergy }

    mutating func applyGravity(to moon: Moon) {
        if x - moon.x < 0 { vx += 1 }
        if x - moon.x > 0 { vx -= 1 }
        if y - moon.y < 0 { vy += 1 }
        if y - moon.y > 0 { vy -= 1 }
        if z - moon.z < 0 { vz += 1 }
        if z - moon.z > 0 { vz -= 1 }
    }

    mutating func applyVelocity() {
        x += vx
        y += vy
        z += vz
    }
}

var moons = [Moon(x: 3, y: 15, z: 8),
             Moon(x: 5, y: -1, z: -2),
             Moon(x: -10, y: 8, z: 2),
             Moon(x: 8, y: 4, z: -5)]

for _ in 1...1000 {
    for idx1 in 0...3 {
        for idx2 in 0...3 {
            if idx1 == idx2 { continue }
            moons[idx1].applyGravity(to: moons[idx2])
        }
    }

    for idx in 0...3 {
        moons[idx].applyVelocity()
    }
}

let totalSystemEnergy = moons.reduce(0) { $0 + $1.totalEnergy }

print("Puzzle 1: The total energy in the sytem is \(totalSystemEnergy)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

struct Component: Hashable {
    var c: Int
    var vc = 0

    mutating func applyGravity(to component: Component) {
        if c - component.c < 0 { vc += 1 }
        if c - component.c > 0 { vc -= 1 }
    }

    mutating func applyVelocity() {
        c += vc
    }
}

var components = [[Component(c: 3), Component(c: 5), Component(c: -10), Component(c: 8)],
                  [Component(c: 15), Component(c: -1), Component(c: 8), Component(c: 4)],
                  [Component(c: 8), Component(c: -2), Component(c: 2), Component(c: -5)]]
var intervals = [Int]()

components.forEach {
    var component = $0
    var steps = 0
    var states = [component.hashValue: steps]

    while true {
        steps += 1
        for idx1 in 0...3 {
            for idx2 in 0...3 {
                if idx1 == idx2 { continue }
                component[idx1].applyGravity(to: component[idx2])
            }
        }

        for idx in 0...3 {
            component[idx].applyVelocity()
        }

        if let first = states[component.hashValue] {
            intervals.append(steps - first)
            break
        }

        states[component.hashValue] = steps
    }
}

intervals.sort()
var maxInterval = intervals[2]

while intervals[2] % intervals[0] != 0 || intervals[2] % intervals[1] != 0 {
    intervals[2] += maxInterval
}

print("Puzzle 2: The number of steps is \(intervals[2])")
