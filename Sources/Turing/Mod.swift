//
//  Mod.swift
//  Turing
//
//  Created by Bugen Zhao on 5/9/20.
//

import Foundation
import TuringLib

func mod(x: Int, y: Int) -> Int {
    guard x > y && y >= 1 else { fatalError() }

    enum Symbol: String, CustomStringConvertible {
        case 👉 = ">", 👈 = "<"
        case rei = "0", ichi = "1"

        static var blank: Symbol? { return nil }
        var description: String { return rawValue }
    }

    enum State {
        case start, halt, readX, toY, decY, testY, toX, resY, revY
    }


    let machine = TuringMachine<State, Symbol>(tapeCount: 1, initialState: .start)
    typealias Inst = Instruction<State, Symbol>

    let instructions: [Inst] = [
        Inst(.start, [.👉], .readX, [.👉], [.R]),
        Inst(.readX, [.ichi], .toY, [.👉], [.R]),
        Inst(.readX, [.blank], .revY, [.👉], [.R]),
        Inst(.toY, [.ichi], .toY, [.ichi], [.R]),
        Inst(.toY, [.blank], .decY, [.blank], [.R]),
        Inst(.decY, [.rei], .decY, [.rei], [.R]),
        Inst(.decY, [.ichi], .testY, [.rei], [.R]),
        Inst(.testY, [.ichi], .toX, [.ichi], [.L]),
        Inst(.testY, [.👈], .resY, [.👈], [.L]),
        Inst(.resY, [.rei], .resY, [.ichi], [.L]),
        Inst(.resY, [.blank], .toX, [.blank], [.L]),
        Inst(.toX, [.rei], .toX, [.rei], [.L]),
        Inst(.toX, [.ichi], .toX, [.ichi], [.L]),
        Inst(.toX, [.blank], .toX, [.blank], [.L]),
        Inst(.toX, [.👉], .readX, [.👉], [.R]),

        Inst(.revY, [.rei], .revY, [.ichi], [.R]),
        Inst(.revY, [.ichi], .revY, [.👈], [.R]),
        Inst(.revY, [.👈], .halt, [.👈], [.S]),
    ]

    var tape = [Symbol?]()
    tape.append(.👉)
    for _ in 1...x { tape.append(.ichi) }
    tape.append(.blank)
    for _ in 1...y { tape.append(.ichi) }
    tape.append(.👈)

    try! machine.addInstruction(from: instructions)
    machine.tapes[0].tape = tape

    machine.run(verbose: false)

    let expected = x % y
    let tm = machine.tapes[0].count(.ichi)
    print("\nResults: \(expected == tm ? "OK".green : "Failed".red)")
    print("\(x) % \(y) = \(expected) ... expected")
    print("\(x) % \(y) = \(tm) ... TM")

    return tm
}
