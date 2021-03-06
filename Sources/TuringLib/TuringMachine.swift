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

    public enum Verbose {
        case no, half, full, latex
    }

    public var tapes: [Tape<Symbol>]
    public private(set) var instructions: [Inst] = [Inst]()

    public var state: State
    public var stepCount: Int = 0
    var checkpoint: ([Symbol?], State)? = nil

    public var tapeCount: Int { return tapes.count }

    @discardableResult
    public func addInstruction(_ instruction: Inst) throws -> Self {
        guard instruction.fromSymbols.count == tapeCount
            && instruction.toSymbols.count == max(tapeCount - 1, 1)
            && instruction.toDirections.count == tapeCount else {
                throw TuringMachineError.incorrectCount
        }
        instructions.append(instruction)
        return self
    }

    @discardableResult
    public func addInstruction(from instructions: [Inst]) throws -> Self {
        instructions.forEach { try! self.addInstruction($0) }
        return self
    }

    @discardableResult
    public func putTape(_ tape: [Symbol?], at tapeIdx: Int) -> Self {
        tapes[tapeIdx].tape = tape
        return self
    }

    public init(tapeCount: Int, initialState: State) {
        self.tapes = .init(repeating: Tape(), count: tapeCount)
        self.state = initialState
    }

    @discardableResult
    public func step(verbose: Verbose = .full) -> Bool {
        let foundInst = instructions.first { inst in
            inst.fromState == state && inst.fromSymbols == tapes.map { try! $0.read() }
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
            let newCheckpoint = (tapes.map { try! $0.read() }, state)
            switch verbose {
            case .latex where checkpoint == nil || newCheckpoint != checkpoint!:
                if let s = self as? CustomLaTeXStringConvertible {
                    print(s.latexDescription)
                } else { fallthrough }
            case .full:
                dump()
            case .half where checkpoint == nil || newCheckpoint != checkpoint!:
                dump()
            default:
                break
            }

            checkpoint = newCheckpoint
            return true
        }

        return false
    }

    public func run(verbose: Verbose = .full) {
        switch verbose {
        case .latex:
            if let s = self as? CustomLaTeXStringConvertible {
                print(s.latexDescription)
            } else { fallthrough }
        case .full, .half:
            dump()
        default:
            break
        }

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


extension TuringMachine: CustomLaTeXStringConvertible where Symbol: CustomLaTeXStringConvertible {
    public var latexDescription: String {
        switch tapeCount {
        case 1:
            return "\\text{Step \(stepCount) }&\\rightarrow(q_{\(state)} &{},{}& \(tapes[0].latexDescription))\\\\"
        default:
            return "Not implemented"
        }
    }

    public func latexDump() {
        print(self.latexDescription)
    }
}
