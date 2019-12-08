// ---------------------------------------------------
//  main.swift
//  Day08
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

import Foundation

let imgWidth = 25
let imgHeight = 6
let imgSize = imgWidth * imgHeight
let imgData = input.utf8.map { $0 - 48 }


// --------------------
//   MARK: - Puzzle 1
// --------------------

var counter: (zero: Int, one: Int, two: Int) = (Int.max, 0, 0)
var fewestZero = counter
var layerStartIndex = 0

while layerStartIndex < imgData.count {
    let layerEndIndex = layerStartIndex + imgSize
    let layer = imgData[layerStartIndex..<layerEndIndex]

    counter = layer.reduce((zero: 0, one: 0, two: 0)) {
        switch $1 {
            case 0: return ($0.zero + 1, $0.one, $0.two)
            case 1: return ($0.zero, $0.one + 1, $0.two)
            case 2: return ($0.zero, $0.one, $0.two + 1)
            default: break
        }
        fatalError()
    }

    fewestZero = fewestZero.zero < counter.zero ? fewestZero : counter
    layerStartIndex = layerEndIndex
}

print("Puzzle 1: The number of 1 digits multiplied by the number of 2 digits is \(fewestZero.one * fewestZero.two)")


// --------------------
//   MARK: - Puzzle 2
// --------------------

print("Puzzle 2:\n")

for y in 0..<imgHeight {
    for x in 0..<imgWidth {
        var currentPixelIndex = y * imgWidth + x

        while currentPixelIndex < imgData.count && imgData[currentPixelIndex] == 2 {
            currentPixelIndex += imgSize
        }

        if currentPixelIndex < imgData.count {
            let pixel = imgData[currentPixelIndex] == 0 ? " " : "*"
            print(pixel, terminator: "")
        }
    }
    print()
}
