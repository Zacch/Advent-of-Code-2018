//
//  PrioQueue.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-28.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class PriorityQueue<T: Any> {
    var queue: [Int:[T]] = [:]
    
    func push(_ object: T, prio: Int) {
        if queue[prio] == nil {
            queue[prio] = [object]
        } else {
            queue[prio]?.append(object)
        }
    }
    
    func pop() -> T? {
        if queue.isEmpty {
            return nil
        }
        let firstKey = queue.keys.sorted().first!
        var array = queue[firstKey]!
        let result = array.first!
        array = Array(array.dropFirst())
        queue[firstKey] = array.isEmpty ? nil : array
        return result
    }
    
    func dump() {
        for key in queue.keys.sorted() {
            print("\(key): \(queue[key]!)")
        }
    }
}
