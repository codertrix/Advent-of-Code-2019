// ---------------------------------------------------
//  main.swift
//  Day06
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

struct Object: Hashable {
    let name: String
    let inOrbit: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

var objects = Set<Object>()

input.split(separator: "\n").forEach { (orbit) in
    let parts = orbit.split(separator: ")")
    objects.insert(Object(name: String(parts[1]), inOrbit: String(parts[0])))
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var orbitsCount = 0

objects.forEach { (object) in
    var nextOrbit = object.inOrbit

    while nextOrbit != "COM" {
        if let nextObject = objects.first(where: { $0.name == nextOrbit }) {
            orbitsCount += 1
            nextOrbit = nextObject.inOrbit
        }
    }

    orbitsCount += 1
}

print("Puzzle 1: The total number of orbits is \(orbitsCount)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

var transfers = Set<String>()
var nextOrbit = objects.first(where: { $0.name == "YOU" })!.inOrbit

while nextOrbit != "COM" {
    if let nextObject = objects.first(where: { $0.name == nextOrbit }) {
        transfers.insert(nextObject.name)
        nextOrbit = nextObject.inOrbit
    }
}

nextOrbit = objects.first(where: { $0.name == "SAN" })!.inOrbit

while nextOrbit != "COM" {
    if let nextObject = objects.first(where: { $0.name == nextOrbit }) {
        if transfers.contains(nextObject.name) {
            transfers.remove(nextObject.name)
        } else {
            transfers.insert(nextObject.name)
        }
        nextOrbit = nextObject.inOrbit
    }
}

print("Puzzle 2: The minimum number of required orbital transfers is \(transfers.count)")
