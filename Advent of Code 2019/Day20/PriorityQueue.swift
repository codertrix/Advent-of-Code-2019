// ---------------------------------------------------
//  PriorityQueue.swift
//  Day18
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

private extension Int {
    var left: Int   { return (self * 2) + 1 }
    var right: Int  { return (self * 2) + 2 }
    var parent: Int { return (self - 1) / 2 }
}

class PriorityQueue<Element: Comparable> {
    private var queue = [Element]()
    public var isEmpty: Bool { return queue.count == 0 }


    func push(_ element: Element) {
        var childIndex = queue.count
        var parentIndex = childIndex.parent

        queue.append(element)

        while queue[parentIndex] > queue[childIndex] {
            queue.swapAt(childIndex, parentIndex)
            childIndex = parentIndex
            parentIndex = childIndex.parent
        }
    }

    func pop() -> Element? {
        guard let root = queue.first else { return nil }
        guard queue.count > 1 else {
            queue.removeLast()
            return root
        }

        queue[0] = queue.removeLast()

        var parentIndex = 0

        while true {
            var childIndex = parentIndex.left
            if childIndex >= queue.count { break }

            let rightIndex = parentIndex.right
            if rightIndex < queue.count && queue[rightIndex] < queue[childIndex] {
                childIndex = rightIndex
            }

            if queue[parentIndex] < queue[childIndex] { break }

            queue.swapAt(parentIndex, childIndex)
            parentIndex = childIndex
        }

        return root
    }
}
