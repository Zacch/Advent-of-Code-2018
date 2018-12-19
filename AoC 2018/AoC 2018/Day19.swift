//
//  Day19.swift
//  AoC 2018
//
//  Created by Rolf Staflin on 2018-12-18.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Foundation

class Statement {
    let opcode: String
    let arguments: [Int]
    
    init(_ opcode: String, _ arguments: [Int]) {
        self.opcode = opcode
        self.arguments = arguments
    }
}

class Day19 {
    
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
        let lines = Utils.readFileLines("Day19.txt")
        ipRegister = Utils.getIntegers(lines[0]).first!

        for line in lines.dropFirst() {
            let opcode = String(line[line.startIndex ..< line.firstIndex(of: " ")!])
            var arguments = [0]
            arguments.append(contentsOf: Utils.getIntegers(line))
            program.append(Statement(opcode, arguments))
        }
        
        print("Part 1: \(part1())")
        print("Part 2: \(part2())")
    }
    
    func part1() -> Int {
        ip = 0
        while ip >= 0 && ip < program.count {
            registers[ipRegister] = ip
            registers = instructions[program[ip].opcode]!.function(program[ip].arguments, registers)
            ip = registers[ipRegister] + 1
        }
        return registers[0]
    }
    
/*
     The program in Day19.txt is a very inefficient way of adding up all the
     divisors of a number. This is line 1 to 16 translated to Swift
     (I call the registers A, B, C, D, E and F for readability):

         for F in 1 ... E {
            for C in 1 ... E {
                if C * F == E {
                    A += F
                }
            }
        }
        return A

     Line 17 through 35 set E to 861 (if A == 0) or 10551261 (if A == 1)
     In part 1 we used E = 861, so there it was OK to run the real code,
     but in part 2 we have E = 10551261, so we must optimize!
     
     We can replace the whole inner loop with a test to see if E is a multiple of F:

        if E % F == 0 {
            A += F
        }
*/

    func part2() -> Int {
        
        var A=0
        let E = 10551261
        
        for F in 1 ... E {
            if E % F == 0 {
                A += F
            }
        }
        return A
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
