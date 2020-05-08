//
//  Tape.swift
//  TuringLib
//
//  Created by Bugen Zhao on 5/8/20.
//

import Foundation
import Rainbow

public class Tape<Symbol>: CustomStringConvertible where Symbol: Equatable {
    public var tape = [Symbol]()
    public var head: Int = 0

    public func move(_ direction: Direction) {
        switch direction {
        case .L:
            head -= 1
        case .R:
            head += 1
        case .S:
            break
        }
    }

    public func write(_ symbol: Symbol) {
        guard 0...tape.count ~= head else { fatalError() }

        if head == tape.count { tape.append(symbol) }
        else { tape[head] = symbol }
    }

    public var description: String {
        var result = "[ "
        for i in 0..<tape.count {
            if i == head { result.append(String(describing: tape[i]).onRed) }
            else { result.append("\(tape[i])") }
            result.append(", ")
        }
        result.append(head == tape.count ? "...".onRed : "...")
        result.append(" ]")
        return result
    }
}
