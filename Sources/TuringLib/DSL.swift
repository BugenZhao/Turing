//
//  DSL.swift
//  TuringLib
//
//  Created by Bugen Zhao on 5/10/20.
//

import Foundation

infix operator ~~>: DefaultPrecedence
public func ~~> <State, Symbol>(_ from: (fromState: State, fromSymbols: [Symbol?]),
    _ to: (toState: State, toSymbols: [Symbol?], toDirections: [Direction])) -> Instruction<State, Symbol> {
    return Instruction<State, Symbol>(from.fromState, from.fromSymbols, to.toState, to.toSymbols, to.toDirections)
}
