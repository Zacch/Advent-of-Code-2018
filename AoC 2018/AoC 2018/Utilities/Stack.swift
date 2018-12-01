//
//  Stack.swift
//  Advent Of Code 2017
//
//  Created by Rolf Staflin on 2017-12-12.
//  Copyright © 2017 Piro AB. All rights reserved.
//

import Foundation


// Copy-pasted with pride from
// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Generics.html

struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    var isEmpty: Bool { get {return items.isEmpty}}
}

