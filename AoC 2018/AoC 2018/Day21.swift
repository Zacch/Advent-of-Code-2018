//
//  Day21.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-20.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Day21 {
    
    // NOTE: The Instruction class was created in Day16.swift
    var instructions: [String: Instruction] = [:]
    var program: [Statement] = []
    var ipRegister = -1
    
    var registers = [0,0,0,0,0,0]
    var ip = 0
    
    init() {
        var instructionArray: [Instruction] = []
        instructionArray.append(Instruction("addr", function: addr))
        instructionArray.append(Instruction("addr", function: addr))
        instructionArray.append(Instruction("addi", function: addi))
        instructionArray.append(Instruction("mulr", function: mulr))
        instructionArray.append(Instruction("muli", function: muli))
        instructionArray.append(Instruction("banr", function: banr))
        instructionArray.append(Instruction("bani", function: bani))
        instructionArray.append(Instruction("borr", function: borr))
        instructionArray.append(Instruction("bori", function: bori))
        instructionArray.append(Instruction("setr", function: setr))
        instructionArray.append(Instruction("seti", function: seti))
        instructionArray.append(Instruction("gtir", function: gtir))
        instructionArray.append(Instruction("gtri", function: gtri))
        instructionArray.append(Instruction("gtrr", function: gtrr))
        instructionArray.append(Instruction("eqir", function: eqir))
        instructionArray.append(Instruction("eqri", function: eqri))
        instructionArray.append(Instruction("eqrr", function: eqrr))
        
        instructionArray.forEach { instructions[$0.name] = $0 }
    }
    
    func solve () {
        let lines = Utils.readFileLines("Day21.txt")
        ipRegister = Utils.getIntegers(lines[0]).first!
        
        for line in lines.dropFirst() {
            let opcode = String(line[line.startIndex ..< line.firstIndex(of: " ")!])
            var arguments = [0]
            arguments.append(contentsOf: Utils.getIntegers(line))
            program.append(Statement(opcode, arguments))
        }
        
        print("Part 1: \(part1([]))")
        print("Part 2: \(part2())")
    }
    
    func part1(_ breakpoints: [Int]) -> Int {
        ip = 0
        while ip >= 0 && ip < program.count {
            let before = registers
            registers[ipRegister] = ip
            registers = instructions[program[ip].opcode]!.function(program[ip].arguments, registers)
            
            if breakpoints.contains(ip) {
                print("\(ip): \(before) \(program[ip].opcode) \(program[ip].arguments.dropFirst()) \(registers)")
            }
            if ip == 28 {
                return registers[1]
            }
            ip = registers[ipRegister] + 1
        }
        return -1
    }
    
    // The same program rewritten in Swift
    func part2() -> Int {
        var values: [Int] = []
        var b = 0, c = 0
        var lastB = 0
        while b >= 0 {
            c = b | 65536
            b = 6663054
            
            while true {
                b += 16777215 & (c & 255)
                b = 16777215 & (b * 65899)
                if c < 256 { break }
                c = c / 256
            }
            if values.contains(b) {
                return(lastB)
            } else {
                values.append(b)
                lastB = b
            }
        }
        return b
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
