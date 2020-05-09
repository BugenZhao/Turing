//
//  Tape.swift
//  TuringLib
//
//  Created by Bugen Zhao on 5/8/20.
//

import Foundation
import Rainbow

public struct Tape<Symbol>: CustomStringConvertible where Symbol: Equatable {
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

    public mutating func read() throws -> Symbol? {
        guard 0... ~= head else { throw TuringMachineError.illegalPosition }
        while head >= tape.count { tape.append(nil) }
        return tape[head]
    }

    public var description: String {
        var result = "[ "
        for i in 0..<tape.count {
            let s = tape[i] == nil ? "?" : String(describing: tape[i]!)
            if i == head { result.append(s.onRed) }
            else { result.append(s) }
            result.append(", ")
        }
        result.append(head == tape.count ? "...".onRed : "...")
        result.append(" ]")
        return result
    }

    public init() {
        tape = [nil]
    }
}
