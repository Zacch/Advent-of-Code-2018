//
//  Queue.swift
//  Advent Of Code 2017
//
//  Created by Rolf Staflin on 2017-12-18.
//  Copyright © 2017 Piro AB. All rights reserved.
//

import Foundation

struct Queue<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element {
        return items.removeFirst()
    }
    
    var isEmpty: Bool { get {return items.isEmpty}}
}
