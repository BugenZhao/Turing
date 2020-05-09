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

    let machine = TuringMachine<State, Symbol>(tapeCount: 2, initialState: .start)
    let instructions: [Instruction<State, Symbol>] = [
        Instruction(.start, [.👉, nil], .moving, [.👉], [.R, .R]),
        Instruction(.moving, [.ichi, nil], .moving, [.rei], [.R, .R]),
        Instruction(.moving, [.rei, nil], .moving, [.ichi], [.R, .R]),
        Instruction(.moving, [.👈, nil], .halt, [.👈], [.S, .S]),
    ]
    let tape: [Symbol?] = [.👉, .rei, .ichi, .rei, .ichi, .rei, .👈]

    try! machine.addInstruction(from: instructions)
    machine.tapes[0].tape = tape


    machine.run()
}
