// ---------------------------------------------------
//  main.swift
//  Day14
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

struct Reaction {
    let producedElement: String
    let producedAmount: Int
    var inputElements = [String: Int]()
}

var allReactions = [String: Reaction]()
let inputLines = input.split(separator: "\n")

inputLines.forEach { (line) in
    var lineParts = line.split(whereSeparator: { " ,>=".contains($0) })
    var element = String(lineParts.removeLast())
    var amount = Int(lineParts.removeLast())!
    var reaction = Reaction(producedElement: element, producedAmount: amount)

    while lineParts.count > 0 {
        element = String(lineParts.removeLast())
        amount = Int(lineParts.removeLast())!
        reaction.inputElements[element] = amount
    }

    allReactions[reaction.producedElement] = reaction
}

var availableElements = ["FUEL": 0]

func resolveReaction(for element: String, neededAmount: Int, ore: inout Int) {
    guard let reaction = allReactions[element] else { fatalError() }

    reaction.inputElements.forEach { (inElement) in
        let neededInput = inElement.value * neededAmount
        if inElement.key == "ORE" {
            ore += neededInput
            return
        }

        guard let preReaction = allReactions[inElement.key] else { fatalError() }
        var available = availableElements[inElement.key] ?? 0
        var needed = 0

        if available >= neededInput {
            available -= neededInput
        } else if preReaction.producedAmount >= neededInput {
            available += preReaction.producedAmount - neededInput
            needed = 1
        } else {
            needed = (neededInput - available + preReaction.producedAmount - 1) / preReaction.producedAmount
            available += needed * preReaction.producedAmount - neededInput
        }

        availableElements[inElement.key] = available
        resolveReaction(for: preReaction.producedElement, neededAmount: needed, ore: &ore)
    }
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

var orePerFuel = 0

resolveReaction(for: "FUEL", neededAmount: 1, ore: &orePerFuel)
print("Puzzle 1: The minimum amount of ORE required is \(orePerFuel)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

let availableOre = 1_000_000_000_000
var remainingOre = availableOre
var maxFuel = 0

repeat {
    availableElements = ["FUEL": 0]
    var usedOre = 0
    maxFuel += remainingOre / orePerFuel
    resolveReaction(for: "FUEL", neededAmount: maxFuel, ore: &usedOre)
    remainingOre = availableOre - usedOre
} while remainingOre >= orePerFuel

print("Puzzle 2: The maximum amount of fuel is \(maxFuel)")
