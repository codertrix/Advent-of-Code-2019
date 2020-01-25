// ---------------------------------------------------
//  main.swift
//  Day22
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------
import Foundation
func numberFrom(_ technique: String) -> Int {
    let parts = technique.split(separator: " ").last
    guard let number = Int(String(parts!)) else { fatalError()}

    return number
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var deckSize = 10007
var position = 2019

for tech in input.split(separator: "\n") {
    if tech.hasPrefix("deal into") {
        position = deckSize - 1 - position
    } else if tech.hasPrefix("deal with") {
        position = (position * numberFrom(String(tech))) % deckSize
    } else {
        var number = numberFrom(String(tech))
        if number < 0 { number = deckSize + number }
        position = position < number ? deckSize - number + position : position - number
    }
}

print("Puzzle 1: The position of card 2019 is \(position)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

// This solution runs "forever" -> it's not a solution

/*
let shuffles = 101_741_582_076_661
deckSize = 119_315_717_514_047
position = 2020

for _ in 1...shuffles {
    for tech in input.split(separator: "\n").reversed() {
        if tech.hasPrefix("deal into") {
            position = deckSize - 1 - position
        } else if tech.hasPrefix("deal with") {
            let number = numberFrom(String(tech))
            var nDecks = 0
            while true {
                if (nDecks + position) % number == 0 {
                    position = (nDecks + position) / number
                    break
                }
                nDecks += deckSize
            }
        } else {
            var number = -numberFrom(String(tech))
            if number < 0 { number = deckSize + number }
            position = position < number ? deckSize - number + position : position - number
        }
    }
}

print("Puzzle 2: The number of the card at position 2020 is \(position)")
*/
