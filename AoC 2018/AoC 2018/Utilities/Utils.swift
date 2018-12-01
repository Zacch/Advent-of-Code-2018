//
//  Utils.swift
//  Advent Of Code 2017
//
//  Created by Rolf Staflin on 2017-12-11.
//  Copyright © 2017 Piro AB. All rights reserved.
//

import Foundation

class Utils {
    
    static func readFile(_ name: String) -> String {
        let fileURL = URL(fileURLWithPath: name)
        do {
            return try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
        } catch let error1 as NSError  {
            print("readFile failed: \(error1)")
            return ""
        }
    }
    
    static func readFileAsJson(_ name: String) -> Any {
        let fileURL = URL(fileURLWithPath: name)
        do {
            let input = try Data(contentsOf: fileURL)
            return try JSONSerialization.jsonObject(with: input, options: [])
        } catch let error as NSError  {
            print("readFileAsJson failed: \(error)")
            return []
        }
    }
    
    static func readFileLines(_ name: String) -> [String] {
            let fileContents = readFile(name)
            let lines = fileContents.split(separator: "\n")
            return lines.map {String($0)}
    }
}
