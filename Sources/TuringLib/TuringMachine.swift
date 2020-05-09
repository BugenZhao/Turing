//
//  TuringMachine.swift
//  TuringLib
//
//  Created by Bugen Zhao on 5/8/20.
//

import Foundation
import Rainbow

public class TuringMachine<State, Symbol> where State: Equatable, Symbol: Equatable {
    public typealias Inst = Instruction<State, Symbol>

    public var tapes: [Tape<Symbol>]
    public private(set) var instructions: [Inst] = [Inst]()

    public var state: State
    public var stepCount: Int = 0

    public var tapeCount: Int { return tapes.count }

    public func addInstruction(_ instruction: Inst) throws {
        guard instruction.fromSymbols.count == tapeCount
            && instruction.toSymbols.count == max(tapeCount - 1, 1)
            && instruction.toDirections.count == tapeCount else {
                throw TuringMachineError.incorrectCount
        }
        instructions.append(instruction)
    }

    public func addInstruction(from instructions: [Inst]) throws {
        instructions.forEach { try! self.addInstruction($0) }
    }

    public init(tapeCount: Int, initialState: State) {
        self.tapes = .init(repeating: Tape(), count: tapeCount)
        self.state = initialState
    }

    @discardableResult
    public func step(verbose: Bool = true) -> Bool {
        let foundInst = instructions.first { inst in
            inst.fromState == state && inst.fromSymbols == tapes.map { tape in
                var tape = tape
                return try! tape.read()
            }
        }

        if let foundInst = foundInst {
            self.state = foundInst.toState
            switch tapeCount {
            case 1:
                try! tapes[0].write(foundInst.toSymbols[0])
                tapes[0].move(foundInst.toDirections[0])
            default:
                tapes[0].move(foundInst.toDirections[0])
                for i in 1..<tapeCount {
                    try! tapes[i].write(foundInst.toSymbols[i - 1])
                    tapes[i].move(foundInst.toDirections[i])
                }
            }

            stepCount += 1
            dump()
            return true
        }

        return false
    }

    public func run(verbose: Bool = true) {
        dump()
        while true {
            if step(verbose: verbose) == false { break }
        }
    }

    public func dump() {
        print(">> Step \(stepCount) => State", "\(state)".green)
        tapes.enumerated().forEach { idx, tape in
            print("Tape \(idx):", tape)
        }
    }
}
