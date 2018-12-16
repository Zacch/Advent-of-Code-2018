//
//  Day16.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-16.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Instruction {
    let name: String
    let function: ([Int], [Int])->[Int]
    
    init(_ opcode:String, function: @escaping ([Int], [Int])->[Int]) {
        self.name = opcode
        self.function = function
    }
}

class Day16 {
    
    var instructions: [Instruction]
    var opcodes:[[Instruction]] = []
    init() {
        instructions = []
        instructions.append(Instruction("addr", function: addr))
        instructions.append(Instruction("addi", function: addi))
        instructions.append(Instruction("mulr", function: mulr))
        instructions.append(Instruction("muli", function: muli))
        instructions.append(Instruction("banr", function: banr))
        instructions.append(Instruction("bani", function: bani))
        instructions.append(Instruction("borr", function: borr))
        instructions.append(Instruction("bori", function: bori))
        instructions.append(Instruction("setr", function: setr))
        instructions.append(Instruction("seti", function: seti))
        instructions.append(Instruction("gtir", function: gtir))
        instructions.append(Instruction("gtri", function: gtri))
        instructions.append(Instruction("gtrr", function: gtrr))
        instructions.append(Instruction("eqir", function: eqir))
        instructions.append(Instruction("eqri", function: eqri))
        instructions.append(Instruction("eqrr", function: eqrr))

        opcodes = Array<[Instruction]>(repeating: instructions, count: 16)
    }
    
    func solve () {
        let lines = Utils.readFileLines("Day16.txt")
        var lineIndex = 0
        var part1 = 0
        var endOfPart1 = 0
        while endOfPart1 == 0 {
            let line = lines[lineIndex]
            if line.starts(with: "Before") {
                let state = Utils.getIntegers(line)
                let instr = Utils.getIntegers(lines[lineIndex + 1])
                let output = Utils.getIntegers(lines[lineIndex + 2])
                let matches = instructions.filter {$0.function(instr, state) == output}
                if matches.count >= 3 {
                    part1 += 1
                }
                let opcode = instr[0]
                opcodes[opcode] = opcodes[opcode].filter{i in matches.contains(where: {$0.name == i.name})}
                lineIndex += 3
            } else {
                endOfPart1 = lineIndex
            }
        }
        print("Part1: \(part1)")

        var knownCodes:[String:Int] = [:]
        while knownCodes.count < 16 {
            for i in 0 ..< 16 {
                let codes = opcodes[i]
                if codes.count == 1 {
                    knownCodes[codes.first!.name] = i
                } else {
                    opcodes[i] = opcodes[i].filter{ knownCodes[$0.name] == nil }
                }
            }
        }

        var state = [0, 0, 0, 0]

        for i in endOfPart1 ..< lines.count {
            let instr = Utils.getIntegers(lines[i])
            state = opcodes[instr[0]].first!.function(instr, state)
        }
        print("Part2: \(state[0])")
    }

//    Addition:
//
//    addr (add register) stores into register C the result of adding register A and register B.
    func addr(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] + result[parameters[2]]
        return result
    }

//    addi (add immediate) stores into register C the result of adding register A and value B.
    func addi(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] + parameters[2]
        return result
    }

//
//    Multiplication:
//
//    mulr (multiply register) stores into register C the result of multiplying register A and register B.
    func mulr(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] * result[parameters[2]]
        return result
    }

//    muli (multiply immediate) stores into register C the result of multiplying register A and value B.
    func muli(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] * parameters[2]
        return result
    }

//
//    Bitwise AND:
//
//    banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
    func banr(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] & result[parameters[2]]
        return result
    }

//    bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
    func bani(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] & parameters[2]
        return result
    }

//
//    Bitwise OR:
//
//    borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
    func borr(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] | result[parameters[2]]
        return result
    }

//    bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
    func bori(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] | parameters[2]
        return result
    }

//
//    Assignment:
//
//    setr (set register) copies the contents of register A into register C. (Input B is ignored.)
    func setr(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]]
        return result
    }

//    seti (set immediate) stores value A into register C. (Input B is ignored.)
    func seti(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = parameters[1]
        return result
    }

//
//    Greater-than testing:
//
//    gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
    func gtir(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = parameters[1] > result[parameters[2]] ? 1: 0
        return result
    }

//    gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
    func gtri(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] > parameters[2] ? 1: 0
        return result
    }

//    gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
    func gtrr(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] > result[parameters[2]] ? 1: 0
        return result
    }

//
//    Equality testing:
//
//    eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
    func eqir(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = parameters[1] == result[parameters[2]] ? 1: 0
        return result
    }

//    eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
    func eqri(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] == parameters[2] ? 1: 0
        return result
    }

//    eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
    func eqrr(_ parameters: [Int],_ state: [Int])->[Int] {
        var result = state
        result[parameters[3]] = result[parameters[1]] == result[parameters[2]] ? 1: 0
        return result
    }
}
