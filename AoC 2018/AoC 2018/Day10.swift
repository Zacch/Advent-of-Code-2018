//
//  Day10.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-08.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Node {
    var children: [Node] = []
    var metadata: [Int] = []
    var sum = 0
    var value = 0
    
    func load(_ tokens: [Int], from index: Int) -> Int {
        var i = index
        let childCount = tokens[i]
        let metadataCount = tokens[i + 1]
        i += 2
        for _ in 0 ..< childCount {
            let child = Node()
            i = child.load(tokens, from: i)
            children.append(child)
            sum += child.sum
        }
        for j in 0 ..< metadataCount {
            let token = tokens[i + j]
            metadata.append(token)
            sum += token
            if childCount == 0 {
                value += token
            }
            if token <= childCount {
                value += children[token - 1].value
            }
        }
        return i + metadataCount
    }
}

class Day10 {
    func solve () {
        let lines = Utils.readFileLines("Day10.txt")
        let tokens = lines[0].components(separatedBy: " ").map { Int($0)! }
        print(tokens)
        let root = Node()
        let _ = root.load(tokens, from: 0)
        print("Part1: \(root.sum)")
        print("Part2: \(root.value)")
    }
}
