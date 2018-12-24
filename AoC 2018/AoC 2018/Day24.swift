//
//  Day24.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-24.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day24 {
    
    var immunityArmy: [ArmyGroup] = []
    var infectionArmy: [ArmyGroup] = []
    
    func solve () {
        parseInput()
        print("Part1: ")
        print("Part2: ")
    }

    fileprivate func parseInput() {
        let lines = Utils.readFileLines("Day24.txt")
        var parsingImmunityArmy = false
        for line in lines {
            let tokens = line.components(separatedBy: " ").map { String($0) }
            if tokens[0] == "Immune" {
                parsingImmunityArmy = true
                continue
            }
            if tokens[0] == "Infection:" {
                parsingImmunityArmy = false
                continue
            }
            let group = ArmyGroup()
            let ints = Utils.getIntegers(line)
            group.units = ints[0]
            group.hitPoints = ints[1]
            group.damage = ints[2]
            group.initiative = ints[3]
            
            // "(immune", "to", "slashing,", "radiation,", "fire;", "weak", "to", "bludgeoning)"
            var index = 9
            if tokens[7] == "(immune" {
                (index, group.immunities) = parseTypes(index, tokens: tokens)
                if tokens[index] == "weak" {
                    (index, group.weaknesses) = parseTypes(index + 2, tokens: tokens)
                }
            }

            if tokens[7] == "(weak" {
                (index, group.weaknesses) = parseTypes(index, tokens: tokens)
                if tokens[index] == "immune" {
                    (_, group.immunities) = parseTypes(index + 2, tokens: tokens)
                }
            }
            group.attackType = tokens[index + 6]

            if parsingImmunityArmy {
                immunityArmy.append(group)
            } else {
                infectionArmy.append(group)
            }
            print(tokens)
        }
    }
    
    func parseTypes(_ startIndex: Int, tokens: [String]) -> (Int, [String]) {
        var index = startIndex
        var types: [String] = []
        var type = tokens[index]
        while type.last! == "," {
            types.append(String(type.dropLast()))
            index += 1
            type = tokens[index]
        }
        types.append(String(type.dropLast()))
        return (index + 1, types)
    }
}

class ArmyGroup {
    var units = 0
    var hitPoints = 0
    var immunities:[String] = []
    var weaknesses:[String] = []
    var attackType = ""
    var damage = 0
    var initiative = 0
    var effectivePower: Int { get { return units * damage } }
}
