//
//  Day02.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-02.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day02 {
    func solve () {
        let lines = Utils.readFileLines("Day02.txt")
        var doubles = 0
        var triples = 0
        for line in lines {
            var occurences:[Character: Int] = [:]
            line.forEach { c in
                let oldCount = occurences[c] ?? 0
                occurences[c] = oldCount + 1
            }
            if (!occurences.values.filter{ $0 == 2 }.isEmpty) {
                doubles += 1
            }
            if (!occurences.values.filter{ $0 == 3 }.isEmpty) {
                triples += 1
            }
        }
        print("Part 1: \(doubles * triples)")
        
        for i in 0 ..< lines.count {
            for j in i + 1 ..< lines.count {
                if oneDiff(lines[i], lines[j]) {
                    return
                }
            }
        }
    }
    
    func oneDiff(_ s1: String, _ s2: String) -> Bool {
        if s1.count != s2.count {
            return false
        }
        var diffIndex: String.Index?
        for i in 0 ..< s1.count {
            let index = s1.index(s1.startIndex, offsetBy: i)
            if s1[index] != s2[index] {
                if diffIndex != nil {
                    return false
                }
                diffIndex = index
            }
        }
        if diffIndex != nil {
            let diffString = s1.prefix(upTo: diffIndex!) + s1.suffix(from: s1.index(diffIndex!, offsetBy: 1))
            print("Part 2: \(diffString)")
            return true
        }
        return false
    }
}
