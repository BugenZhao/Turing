//
//  Instruction.swift
//  TuringLib
//
//  Created by Bugen Zhao on 5/8/20.
//

import Foundation

public enum Direction: String, Equatable, Hashable {
    case L, R, S
    static var left: Direction { .L }
    static var right: Direction { .R }
    static var stay: Direction { .S }
}


public struct Instruction<State, Symbol> where State: Equatable, Symbol: Equatable {
    public let fromState: State
    public let fromSymbols: [Symbol?]

    public let toState: State
    public let toSymbols: [Symbol?]
    public let toDirections: [Direction]

    public init(_ fromState: State, _ fromSymbols: [Symbol?], _ toState: State, _ toSymbols: [Symbol?], _ toDirections: [Direction]) {
        self.fromState = fromState
        self.fromSymbols = fromSymbols
        self.toState = toState
        self.toSymbols = toSymbols
        self.toDirections = toDirections
    }
}

extension Instruction: CustomLaTeXStringConvertible where Symbol: CustomLaTeXStringConvertible {
    public var latexDescription: String {
        let from = fromSymbols.map { symbol in
            return symbol == nil ? "\\Box" : symbol!.latexDescription // square
        }.joined(separator: ", ")

        let to = toSymbols.map { symbol in
            return symbol == nil ? "\\Box" : symbol!.latexDescription // square
        }.joined(separator: ", ")

        let dir = toDirections.map(\.rawValue).joined(separator: ", ")

        return "\\langle q_{\(fromState)}, \(from) \\rangle &\\rightarrow \\langle q_{\(toState)}, \(to), \(dir) \\rangle"
    }
}
