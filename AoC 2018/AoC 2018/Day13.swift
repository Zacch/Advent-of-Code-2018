//
//  Day13.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-13.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Cart {
    var x: Int
    var y: Int
    var direction: Int       // N, E, S, W (N == 0)
    var nextTurn = 0         // left, straight, right
    
    init(x: Int, y: Int, direction: Int) {
        self.x = x
        self.y = y
        self.direction = direction
    }
}

class Day13 {
    
    var track: [String] = []
    var carts: [Cart] = []
    
    func solve () {
        let lines = Utils.readFileLines("Day13.txt")
        var y = 0
        for line in lines {
            var trackLine = ""
            var x = 0
            for c in line {
                switch c {
                case "^":
                    carts.append(Cart(x: x, y: y, direction: 0))
                    trackLine.append("|")
                case ">":
                    carts.append(Cart(x: x, y: y, direction: 1))
                    trackLine.append("-")
                case "v":
                    carts.append(Cart(x: x, y: y, direction: 2))
                    trackLine.append("|")
                case "<":
                    carts.append(Cart(x: x, y: y, direction: 3))
                    trackLine.append("-")
                default:
                    trackLine.append(c)
                }
                x += 1
            }
            track.append(trackLine)
            y += 1
        }

        var tick = 1
        var part1Done = false
        var part2done = false
        while !part2done {
            var sortedCarts = carts.sorted(by: {c1, c2 in
                c1.y < c2.y || (c1.y == c2.y && c1.x < c2.x)
            })
            for cart in sortedCarts {
                switch cart.direction {
                case 0:
                    cart.y -= 1
                case 1:
                    cart.x += 1
                case 2:
                    cart.y += 1
                case 3:
                    cart.x -= 1
                default:
                    print("ERROR.")
                    part2done = true
                }

                if (carts.filter { $0.x == cart.x && $0.y == cart.y }).count > 1 {
                    if !part1Done {
                        print("Part1: \(cart.x),\(cart.y)")
                        part1Done = true
                    }
                    carts = carts.filter { $0.x != cart.x && $0.y != cart.y }
                    sortedCarts = sortedCarts.filter { $0.x != cart.x && $0.y != cart.y }
                    if carts.count == 1 {
                        part2done = true
                    }
                    
                }

                let trackChar = trackAt(cart.x, cart.y)
                switch trackChar {
                case "/":
                    switch cart.direction {
                    case 0:
                        cart.direction = 1
                    case 1:
                        cart.direction = 0
                    case 2:
                        cart.direction = 3
                    case 3:
                        cart.direction = 2
                    default:
                        print("ERROR")
                    }
                case "\\":
                    switch cart.direction {
                    case 0:
                        cart.direction = 3
                    case 1:
                        cart.direction = 2
                    case 2:
                        cart.direction = 1
                    case 3:
                        cart.direction = 0
                    default:
                        print("ERROR")
                    }
                case "+":
                    switch cart.nextTurn {
                    case 0: // Left
                        cart.direction = (cart.direction + 3) % 4
                    case 1: // Straight
                        nop()
                    case 2: // Right
                        cart.direction = (cart.direction + 1) % 4
                    default:
                        print("ERROR")
                    }
                    cart.nextTurn = (cart.nextTurn + 1) % 3
                case " ":
                    print("ERROR")
                default:
                    nop()
                }
            }
            tick += 1
        }

        print("Part2: \(carts[0].x),\(carts[0].y)")
    }
    
    func trackAt(_ x: Int, _ y: Int) -> Character {
        return track[y][track[y].index(track[y].startIndex, offsetBy: x)]
    }

    func nop() {}
}
