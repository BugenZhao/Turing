//
//  Example.swift
//  Turing
//
//  Created by Bugen Zhao on 5/9/20.
//

import Foundation
import TuringLib

func example() {
    enum Symbol: String, CustomStringConvertible {
        case 👉, 👈
        case rei = "0", ichi = "1"
        var description: String { return rawValue }
    }
    enum State {
        case start, halt, moving
    }


    let instructions: [Instruction<State, Symbol>] = [
        (.start, [.👉, nil]) ~~> (.moving, [.👉], [.R, .R]),
        (.moving, [.ichi, nil]) ~~> (.moving, [.rei], [.R, .R]),
        (.moving, [.rei, nil]) ~~> (.moving, [.ichi], [.R, .R]),
        (.moving, [.👈, nil]) ~~> (.halt, [.👈], [.S, .S]),
    ]
    let tape: [Symbol?] = [.👉, .rei, .ichi, .rei, .ichi, .rei, .👈]


    try! TuringMachine<State, Symbol>(tapeCount: 2, initialState: .start)
        .addInstruction(from: instructions)
        .putTape(tape, at: 0)
        .run()
}
