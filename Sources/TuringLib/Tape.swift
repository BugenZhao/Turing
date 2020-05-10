//
//  Tape.swift
//  TuringLib
//
//  Created by Bugen Zhao on 5/8/20.
//

import Foundation
import Rainbow

public struct Tape<Symbol>: CustomStringConvertible where Symbol: Equatable {
    public typealias ContentSymbol = Symbol

    public var tape = [Symbol?]()
    public var head: Int = 0

    public mutating func move(_ direction: Direction) {
        switch direction {
        case .L:
            head -= 1
        case .R:
            head += 1
        case .S:
            break
        }
        while head >= tape.count { tape.append(nil) }
    }

    public mutating func write(_ symbol: Symbol?) throws {
        guard 0... ~= head else { throw TuringMachineError.illegalPosition }
        while head >= tape.count { tape.append(nil) }
        tape[head] = symbol
    }

    public func read() throws -> Symbol? {
        guard 0..<tape.count ~= head else { throw TuringMachineError.illegalPosition }
        return tape[head]
    }

    public func count(_ symbol: Symbol?) -> Int {
        return self.tape.reduce(0) { $0 + ($1 == symbol ? 1 : 0) }
    }

    public var description: String {
        var result = "[ "
        for i in 0..<tape.count {
            let s = tape[i] == nil ? "\u{25a1}" : String(describing: tape[i]!) // square
            if i == head { result.append((s + "\u{332}").onRed) } // underline
            else { result.append(s) }
            result.append(" ")
        }
        result.append(head == tape.count ? "...".onRed : "...")
        result.append(" ]")
        return result
    }

    public init() {
        tape = [nil]
    }
}


extension Tape: CustomLaTeXStringConvertible where Symbol: CustomLaTeXStringConvertible {
    public var latexDescription: String {
        var result = ""
        for i in 0..<tape.count {
            let s = tape[i] == nil ? "\\Box" : tape[i]!.latexDescription
            if i == head { result.append("\\underline{\(s)}") }
            else { result.append(s) }
            result.append("  ")
        }
        return result
    }
}
