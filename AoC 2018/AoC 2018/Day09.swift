//
//  Day11.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-09.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class LinkedNode {
    var previous: LinkedNode?
    var next: LinkedNode?
    var value: Int
    
    init(_ value: Int) {
        self.value = value
    }
}

class Day09 {
    func solve () {
        let players = 411
        let lastMarble = 71170
        
        var score = Array<Int>(repeating: 0, count: players)
        var marbles:[Int] = [0, 2, 1]
        var currentMarble = 1
        for i in 3 ... lastMarble {
            if i % 23 == 0 {
                let player = (i - 1) % players
                score[player] += i
                currentMarble = currentMarble - 7
                if currentMarble < 0 {
                    currentMarble += marbles.count
                }
                score[player] += marbles.remove(at: currentMarble)
            } else {
                currentMarble = currentMarble + 2
                if currentMarble > marbles.count {
                    currentMarble -= marbles.count
                }
                marbles.insert(i, at: currentMarble)
            }
        }
        print("Part1: \(score.max()!)")
        part2()
    }
    
    func part2 () {
        let players = 411
        let lastMarble = 7117000

        var score = Array<Int>(repeating: 0, count: players)
        var currentMarble = LinkedNode(0)
        currentMarble.next = currentMarble
        currentMarble.previous = currentMarble

        for i in 1 ... lastMarble {
            if i % 23 == 0 {
                let player = (i - 1) % players
                score[player] += i
                currentMarble = currentMarble.previous!.previous!.previous!.previous!.previous!.previous!
                score[player] += currentMarble.value
                currentMarble.previous!.next = currentMarble.next
                currentMarble.next!.previous = currentMarble.previous
            } else {
                currentMarble = currentMarble.next!.next!
                let newNode = LinkedNode(i)
                newNode.next = currentMarble.next
                newNode.previous = currentMarble
                currentMarble.next = newNode
                newNode.next!.previous = newNode
            }
        }
        print("Part2: \(score.max()!)")
    }
}
