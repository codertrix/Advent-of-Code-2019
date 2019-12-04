// ---------------------------------------------------
//  main.swift
//  Day04
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

// Puzzle input: 171309-643603
let minimum = 177777    // optimized
let maximum = 599999    // input
var passwordCount1 = 0
var passwordCount2 = 0

for toCheck in minimum...maximum {
    let password = Array(" \(toCheck) ".utf8)
    var isValidPassword = false

    for index in 1...5 {
        let c1 = password[index]
        let c2 = password[index + 1]

        if c1 > c2 {
            isValidPassword = false
            break
        }

        if c1 == c2 { isValidPassword = true }
    }

    if isValidPassword {
        passwordCount1 += 1

        // Puzzle 2
        for index in 0...4 {
            let c1 = password[index + 1]
            let c2 = password[index + 2]

            if password[index] != c1 && c1 == c2 && c2 != password[index + 3] {
                passwordCount2 += 1
                break
            }
        }
    }
}

// --------------------
//   MARK: - Puzzle 1
// --------------------

print("Puzzle 1: There are \(passwordCount1) different passwords.")

// --------------------
//   MARK: - Puzzle 2
// --------------------

print("Puzzle 2: There are \(passwordCount2) different passwords.")
