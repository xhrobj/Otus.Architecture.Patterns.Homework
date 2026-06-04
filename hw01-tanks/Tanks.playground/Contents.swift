import Foundation

typealias FieldSize = UInt
typealias Coordinate = UInt
typealias Velocity = UInt
typealias PlayerIcon = Character
typealias Player = Movement & Visual & Rotatement

enum Direction: CaseIterable {
    case north, east, south, west

    static func random() -> Direction {
        Direction.allCases.shuffled().first ?? .north
    }
}

struct Position {
    let y: Coordinate
    let x: Coordinate

    static func zero() -> Position {
        Position(y: 0, x: 0)
    }

    static func random(fieldSize: FieldSize) -> Position {
        Position(y: Coordinate.random(in: 0..<fieldSize), x: Coordinate.random(in: 0..<fieldSize))
    }
}

protocol Visual {
    var symbol: PlayerIcon { get }
    func toString() -> String
}

protocol Movement {
    var velocity: Velocity { get }
    var position: Position { get }
    var direction: Direction { get }
    func placeInPosition(_ position: Position)
}

protocol Rotatement {
    var direction: Direction { get }
    func changeDirection(_ direction: Direction)
}

class Move {
    var object: Movement

    init(object: Movement) {
        self.object = object
    }

    func execute() {
        let newPosition: Position
        switch object.direction {
        case .north:
            newPosition = Position(y: object.position.y - object.velocity, x: object.position.x)
        case .east:
            newPosition = Position(y: object.position.y, x: object.position.x + object.velocity)
        case .south:
            newPosition = Position(y: object.position.y + object.velocity, x: object.position.x)
        case .west:
            newPosition = Position(y: object.position.y, x: object.position.x - object.velocity)
        }
        object.placeInPosition(newPosition)
    }
}

class Rotate {
    var object: Rotatement

    init(object: Rotatement) {
        self.object = object
    }

    func execute() {
        guard let newDirecton = Direction.allCases.shuffled().first(where: { $0 != object.direction }) else { return }
        object.changeDirection(newDirecton)
    }
}

class Tank: Visual, Movement, Rotatement {
    let symbol: PlayerIcon
    let velocity: Velocity = 1
    private(set) var position: Position
    private(set) var direction: Direction

    init(symbol: PlayerIcon, position: Position) {
        self.symbol = symbol
        self.position = position
        self.direction = Direction.random()
    }

    func placeInPosition(_ position: Position) {
        self.position = position
    }

    func changeDirection(_ direction: Direction) {
        self.direction = direction
    }

    func toString() -> String {
        String(symbol)
    }
}

class FieldCell {
    private(set) var player: Visual? = nil

    var hasPlayer: Bool {
        player != nil
    }

    func reset() {
        player = nil
    }

    func placePlayer(_ player: Visual) {
        self.player = player
    }

    func toString() -> String {
        player?.toString() ?? "."
    }
}

class Field {
    let size: FieldSize // размер [квадратного] поля
    var players: [Player]
    var cells: [[FieldCell]]

    init(size: FieldSize, players: [Player]) {
        self.size = size
        self.players = players
        var cells = [[FieldCell]]()
        for _ in 0..<size {
            var row = [FieldCell]()
            for _ in 0..<size {
                row.append(FieldCell())
            }
            cells.append(row)
        }
        self.cells = cells
        reset()
    }

    func move() {
        for player in players {
            // очищаем клетку поля с текущим положением игрока
            cells[Int(player.position.y)][Int(player.position.x)].reset()

            // если игрок упирается в границы поля, поворачиваем его до тех пор пока он не будет смореть на свободную клетку
            let fieldBoundary = size - 1
            while
                (player.direction == .north && player.position.y == 0) || (player.direction == .south && player.position.y == fieldBoundary) ||
                (player.direction == .west && player.position.x == 0) || (player.direction == .east && player.position.x == fieldBoundary)
            {
                let rotater = Rotate(object: player)
                rotater.execute()
            }

            // двигаем игрока
            let mover = Move(object: player)
            mover.execute()

            // заносим положение игрока в новую клетку
            cells[Int(player.position.y)][Int(player.position.x)].placePlayer(player)
        }
    }

    func toString() -> String {
        var r = "\n"
        for y in 0..<size {
            for x in 0..<size {
                r += cells[Int(y)][Int(x)].toString()
            }
            r += "\n"
        }
        return r
    }

    private func reset() {
        cells.forEach { row in
            row.forEach { cell in
                cell.reset()
            }
        }
        for player in players {
            placeInRandomPosition(player: player)
        }
    }

    private func placeInRandomPosition(player: Player) {
        while true {
            let position = Position.random(fieldSize: size)
            let y = Int(position.y), x = Int(position.x)
            if !cells[y][x].hasPlayer {
                cells[y][x].placePlayer(player)
                player.placeInPosition(position)
                return
            }
        }
    }
}

let tank1 = Tank(symbol: "H", position: Position.zero())
let tank2 = Tank(symbol: "O", position: Position.zero())
let gameField = Field(size: 10, players: [tank1, tank2])
print(gameField.toString())

for _ in 1...100 { // Цикл событий на 100 ходов
    sleep(1)
    gameField.move()
    print(gameField.toString())
}
