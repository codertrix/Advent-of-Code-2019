// ---------------------------------------------------
//  main.swift
//  Day01
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation


// --------------------
//   MARK: - Puzzle 1
// --------------------

var sumOfFuel = 0

for mass in masses {
    sumOfFuel += mass / 3 - 2
}

print("The sum of fuel required is \(sumOfFuel)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

sumOfFuel = 0

for var mass in masses {
    mass = mass / 3 - 2

    while mass > 0 {
        sumOfFuel += mass
        mass = mass / 3 - 2
    }
}

print("The sum of fuel required is \(sumOfFuel)")
