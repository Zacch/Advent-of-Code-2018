//
//  main.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-01.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation


let day = Day22()
let startTime = CFAbsoluteTimeGetCurrent()
day.solve()
let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print("Solved in \(timeElapsed) s.")
let _ = readLine()
