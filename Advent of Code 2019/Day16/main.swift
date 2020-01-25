// ---------------------------------------------------
//  main.swift
//  Day16
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

let list = input.utf8.map { Int($0 - 48) }


// --------------------
//   MARK: - Puzzle 1
// --------------------

var inputList = list
var outputList = [Int]()
let basePattern = [0, 1, 0, -1]

for _ in 1...100 {
    outputList = []
    for outIndex in 1...inputList.count {
        var outputNumber = 0
        for (index, number) in inputList.enumerated() {
            outputNumber += number * basePattern[((index + 1) / outIndex) % 4]
        }
        outputList.append(abs(outputNumber % 10))
    }
    inputList = outputList
}

var first8Digits = ""
for index in 0...7 { first8Digits += "\(outputList[index])" }

print("Puzzle 1: The first eight digits after 100 FFT are \(first8Digits)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

let offset = list[0...6].reduce(0) { $0 * 10 + $1 }
var list10000 = [Int]()
for _ in 1...10000 { list10000 += list }

list10000 = Array(list10000[offset...])

for _ in 1...100 {
    var value = 0
    for index in stride(from: list10000.count - 1, to: 0, by: -1) {
        value += list10000[index]
        list10000[index] = value % 10
    }
}

first8Digits = ""
for index in 0...7 { first8Digits += "\(list10000[index])" }

print("Puzzle 2: The eight digits at offset \(offset) after 100 FFT are \(first8Digits)")
