import TuringLib

enum Symbol {
    case 👉, 👈
    case zero, one
}

enum State {
    case start, halt
    case moving
}

let machine = TuringMachine<State, Symbol>(tapeCount: 1, initialState: .start)

let instructions: [Instruction<State, Symbol>] = [
    Instruction(.start, [.👉], .moving, [.👉], [.R]),
    Instruction(.moving, [.one], .moving, [.zero], [.R]),
    Instruction(.moving, [.zero], .moving, [.one], [.R]),
    Instruction(.moving, [.👈], .halt, [.👈], [.R]),
]

machine.tapes[0].tape = [.👉, .zero, .one, .zero, .one, .zero, .👈]

try! machine.addInstruction(from: instructions)

machine.run()
