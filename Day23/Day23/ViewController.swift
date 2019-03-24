//
//  ViewController.swift
//  Day23
//
//  Created by Rolf Staflin on 2018-12-27.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var diagram: Diagram!

    @IBAction func xyPressed(_ sender: Any) {
        print("XY")
        diagram.type = .xy
        diagram.setNeedsDisplay(diagram.bounds)
    }
    
    @IBAction func xzPressed(_ sender: Any) {
        print("XZ")
        diagram.type = .xz
        diagram.setNeedsDisplay(diagram.bounds)
    }
    
    @IBAction func yzPressed(_ sender: Any) {
        print("YZ")
        diagram.type = .yz
        diagram.setNeedsDisplay(diagram.bounds)
    }
}

