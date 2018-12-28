//
//  PrioQueue.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-28.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class PriorityQueue<T: Hashable> {
    var queue: [Int:Set<T>] = [:]
    
    func push(_ object: T, prio: Int) {
        if queue.keys.contains(prio) {
            queue[prio]!.insert(object)
        } else {
            queue[prio] = Set([object])
        }
    }
    
    func pop() -> T? {
        if queue.isEmpty {
            return nil
        }
        let firstKey = queue.keys.sorted().first!
        let result = queue[firstKey]!.popFirst()
        if queue[firstKey]!.isEmpty {
            queue[firstKey] = nil
        }
        return result
    }
    
    func dump() {
        for key in queue.keys.sorted() {
            print("\(key): \(queue[key]!)")
        }
    }
}
