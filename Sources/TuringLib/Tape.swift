//
//  Tape.swift
//  TuringLib
//
//  Created by Bugen Zhao on 5/8/20.
//

import Foundation

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
        return "\(tape), head=\(head)"
    }
}
