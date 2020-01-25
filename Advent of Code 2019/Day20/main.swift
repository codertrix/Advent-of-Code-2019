// ---------------------------------------------------
//  main.swift
//  Day20
//
//  Copyright © 2019 Michael Fenske. See LICENSE.txt.
// ---------------------------------------------------

let maze = input.split(separator: "\n").map { $0.map { Character(String($0)) } }
let rows = maze.count
let columns = maze[0].count

struct Portal: Equatable, Hashable {
    let name: String
    var x1, y1: Int
    var x2, y2: Int

    static func == (lhs: Portal, rhs: Portal) -> Bool { lhs.name == rhs.name }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct Position: Comparable, Equatable, Hashable {
    let x, y, d, l: Int

    static func < (lhs: Position, rhs: Position) -> Bool { lhs.d < rhs.d }
    static func == (lhs: Position, rhs: Position) -> Bool { lhs.x == rhs.x && lhs.y == rhs.y && lhs.l == rhs.l }

    init(_ x: Int, _ y: Int, _ d: Int, _ l: Int = 0) {
        self.x = x
        self.y = y
        self.d = d
        self.l = l
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(l)
    }
}

var portals = Set<Portal>()

for x in 0..<columns - 1 {
    for y in 0..<rows - 1 {
        if maze[y][x].isLetter {
            var portal = Portal(name: "", x1: 0, y1: 0, x2: 0, y2: 0)
            switch (x, y) {
                case (_, 0):
                    portal = Portal(name: String(maze[0][x]) + String(maze[1][x]), x1: x, y1: y + 2, x2: 0, y2: 0)
                case (_, rows - 2):
                    portal = Portal(name: String(maze[rows - 2][x]) + String(maze[rows - 1][x]), x1: x, y1: y - 1, x2: 0, y2: 0)
                case (0, _):
                    portal = Portal(name: String(maze[y][0]) + String(maze[y][1]), x1: x + 2, y1: y, x2: 0, y2: 0)
                case (columns - 2, _):
                    portal = Portal(name: String(maze[y][columns - 2]) + String(maze[y][columns - 1]), x1: x - 1, y1: y, x2: 0, y2: 0)
                default:
                    if maze[y - 1][x] == "." {
                        portal = Portal(name: String(maze[y][x]) + String(maze[y + 1][x]), x1: 0, y1: 0, x2: x, y2: y - 1)
                    } else if maze[y + 1][x].isLetter {
                        portal = Portal(name: String(maze[y][x]) + String(maze[y + 1][x]), x1: 0, y1: 0, x2: x, y2: y + 2)
                    } else if maze[y][x - 1] == "." {
                        portal = Portal(name: String(maze[y][x]) + String(maze[y][x + 1]), x1: 0, y1: 0, x2: x - 1, y2: y)
                    } else if maze[y][x + 1].isLetter {
                        portal = Portal(name: String(maze[y][x]) + String(maze[y][x + 1]), x1: 0, y1: 0, x2: x + 2, y2: y)
                    }
            }

            if portal.name.isEmpty { continue }

            if let p = portals.first(where: { $0 == portal }) {
                portal.x1 += p.x1
                portal.y1 += p.y1
                portal.x2 += p.x2
                portal.y2 += p.y2
            }

            portals.update(with: portal)
        }
    }
}

func steps(from startPos: Position, to destPos: Position, recursive: Bool = false) -> Int {
    let dx = [0, 1, 0, -1]
    let dy = [-1, 0, 1, 0]
    let queue = PriorityQueue<Position>()
    var seen = Set<Position>()

    queue.push(startPos)

    while !queue.isEmpty {
        guard let pos = queue.pop() else { fatalError() }

        if seen.contains(pos) { continue }
        seen.insert(pos)

        if pos.l == 0 && pos.x == destPos.x && pos.y == destPos.y { return pos.d }

        for index in 0...3 {
            var x = pos.x + dx[index]
            var y = pos.y + dy[index]

            if maze[y][x] == "." {
                var dd = 1
                var dl = 0
                if let portal = portals.first(where: { ($0.x1 == x && $0.y1 == y) || ($0.x2 == x && $0.y2 == y) }) {
                    if x == portal.x1 && y == portal.y1 {
                        if !recursive || pos.l > 0 {
                            x = portal.x2
                            y = portal.y2
                            dl = recursive ? -1 : 0
                            dd = 2
                        }
                    } else {
                        x = portal.x1
                        y = portal.y1
                        dl = recursive ? 1 : 0
                        dd = 2
                    }
                }

                queue.push(Position(x, y, pos.d + dd, pos.l + dl))
            }
        }
    }

    return -1
}


// --------------------
//   MARK: - Puzzle 1
// --------------------

guard let aa = portals.first(where: { $0.name == "AA" }), let zz = portals.first(where: { $0.name == "ZZ" }) else { fatalError() }
portals.remove(aa)
portals.remove(zz)

let startPos = Position(aa.x1, aa.y1, 0)
let destPos = Position(zz.x1, zz.y1, Int.max)

print("Puzzle 1: It takes \(steps(from: startPos, to: destPos)) steps")


// --------------------
//   MARK: - Puzzle 2
// --------------------

print("Puzzle 2: It takes \(steps(from: startPos, to: destPos, recursive: true)) steps")
