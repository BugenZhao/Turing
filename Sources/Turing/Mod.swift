//
//  Mod.swift
//  Turing
//
//  Created by Bugen Zhao on 5/9/20.
//

import Foundation
import TuringLib

infix operator %%: MultiplicationPrecedence

@discardableResult
func %%(x: Int, y: Int) -> Int {
    guard x > y && y >= 1 else { fatalError() }

    enum Symbol: String, CustomStringConvertible, CustomLaTeXStringConvertible {
        case 👉 = ">", 👈 = "<"
        case rei = "0", ichi = "1"

        static var blank: Symbol? { return nil }

        var description: String { return rawValue }
        var latexDescription: String {
            switch self {
            case .👉:
                return "\\triangleright"
            case .👈:
                return "\\triangleleft"
            default:
                return rawValue
            }
        }
    }

    enum State {
        case start, halt, readX, toY, decY, testY, toX, resY, revY
    }


    let machine = TuringMachine<State, Symbol>(tapeCount: 1, initialState: .start)
    typealias Inst = Instruction<State, Symbol>

    let instructions: [Inst] = [
        (.start, [.👉]) ~~> (.readX, [.👉], [.R]),
        (.readX, [.ichi]) ~~> (.toY, [.👉], [.R]),
        (.readX, [.blank]) ~~> (.revY, [.👉], [.R]),
        (.toY, [.ichi]) ~~> (.toY, [.ichi], [.R]),
        (.toY, [.blank]) ~~> (.decY, [.blank], [.R]),
        (.decY, [.rei]) ~~> (.decY, [.rei], [.R]),
        (.decY, [.ichi]) ~~> (.testY, [.rei], [.R]),
        (.testY, [.ichi]) ~~> (.toX, [.ichi], [.L]),
        (.testY, [.👈]) ~~> (.resY, [.👈], [.L]),
        (.resY, [.rei]) ~~> (.resY, [.ichi], [.L]),
        (.resY, [.blank]) ~~> (.toX, [.blank], [.L]),
        (.toX, [.rei]) ~~> (.toX, [.rei], [.L]),
        (.toX, [.ichi]) ~~> (.toX, [.ichi], [.L]),
        (.toX, [.blank]) ~~> (.toX, [.blank], [.L]),
        (.toX, [.👉]) ~~> (.readX, [.👉], [.R]),
        (.revY, [.rei]) ~~> (.revY, [.ichi], [.R]),
        (.revY, [.ichi]) ~~> (.revY, [.👈], [.R]),
        (.revY, [.👈]) ~~> (.halt, [.👈], [.S]),
    ]

    // instructions.forEach { print($0.latexDescription + " &{}\\cdots{}&\n\\text{Description}\\\\") }
    // print()

    var tape = [Symbol?]()
    tape.append(.👉)
    for _ in 1...x { tape.append(.ichi) }
    tape.append(.blank)
    for _ in 1...y { tape.append(.ichi) }
    tape.append(.👈)

    try! machine.addInstruction(from: instructions)
    machine.tapes[0].tape = tape

    machine.run(verbose: .half)

    let expected = x % y
    let tm = machine.tapes[0].count(.ichi)
    print("\nResults: \(expected == tm ? "OK".green : "Failed".red)")
    print("\(x) % \(y) = \(expected) ... expected")
    print("\(x) % \(y) = \(tm) ... TM")

    return tm
}
