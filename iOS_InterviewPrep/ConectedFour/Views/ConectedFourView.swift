import SwiftUI

struct ConectedFourView: View {
    @State var viewModel: ConectedFourViewModel = .init()
    var body: some View {
        Text(viewModel.winner != nil ? "Winner: \(viewModel.winner!)" : "Connected Four")
            .font(.title)
        Spacer()
        Text(viewModel.boardVisualRepresentation)
            .monospaced()
        HStack(spacing: 20) {
            Button("Col 1") {
                viewModel.dropDisk(in: 0)
            }
            Button("Col 2") {
                viewModel.dropDisk(in: 1)
            }
            Button("Col 3") {
                viewModel.dropDisk(in: 2)
            }
            Button("Col 4") {
                viewModel.dropDisk(in: 3)
            }
            Button("Col 5") {
                viewModel.dropDisk(in: 4)
            }
            Button("Col 6") {
                viewModel.dropDisk(in: 5)
            }
            Button("Col 7") {
                viewModel.dropDisk(in: 6)
            }
        }
        Spacer()
        HStack {
            Button("Reset Game") {
                viewModel.resetGame()
            }
        }
    }
}

#Preview {
    ConectedFourView(viewModel: .init())
}

enum Player {
    case player1
    case player2
}

@Observable
class ConectedFourViewModel {
    var boardModel = BoardModel()
    var boardVisualRepresentation: String = ""
    var currentPlayer: Player = .player1
    var isWinner: Bool = false
    var winner: Player? = nil
    
    init() {
        printBoard()
    }
    
    func dropDisk(in column: Int) {
        var result: (row: Int, column: Int) = (0, 0)
        if boardModel.dropPiece(column: column, mark: currentPlayer == .player1 ? 1 : -1, result: &result) {
            printBoard()
            if checkWinner(row: result.row, column: result.column, player: currentPlayer == .player1 ? 1 : -1) {
                winner = currentPlayer
            }
            self.currentPlayer = self.currentPlayer == .player1 ? .player2 : .player1
        }
    }
    var horizontalCounter = 0
    var verticalCounter = 0
    var diagonalCounter = 0
    var reverseDiagonalCounter = 0
    
    func checkWinner(row: Int, column: Int, player: Int) -> Bool {
        let leftEdge = max(column - 3, 0)
        let rightEdge = min(column + 3, 6)
        let topEdge = max(row - 3, 0)
        let bottomEdge = min(row + 3, 5)
        
        var horizontalCounter = 0
        for i in leftEdge...rightEdge {
            if boardModel.board[row][i] == player {
                horizontalCounter += 1
                if horizontalCounter == 4 {
                    return true
                }
            } else {
                horizontalCounter = 0
            }
        }
        
        var verticalCounter = 0
        for i in topEdge...bottomEdge {
            if boardModel.board[i][column] == player {
                verticalCounter += 1
                if verticalCounter == 4 {
                    return true
                }
            } else {
                verticalCounter = 0
            }
        }
        
        let rows = boardModel.board.count        // 6
        let cols = boardModel.board[0].count     // 7
        
        // ↘️ check (top-left → bottom-right)
        for r in 0..<(rows - 3) {
            for c in 0..<(cols - 3) {
                let mark = boardModel.board[r][c]
                if mark != 0 &&
                    mark == boardModel.board[r + 1][c + 1] &&
                    mark == boardModel.board[r + 2][c + 2] &&
                    mark == boardModel.board[r + 3][c + 3] {
                    return true
                }
            }
        }
        // ↗️ check (bottom-left → top-right)
        for r in 3..<rows {
                for c in 0..<(cols - 3) {
                    let mark = boardModel.board[r][c]
                    if mark != 0 &&
                        mark == boardModel.board[r - 1][c + 1] &&
                        mark == boardModel.board[r - 2][c + 2] &&
                        mark == boardModel.board[r - 3][c + 3] {
                        return true
                    }
                }
            }
        
        return false
    }
    
    func resetGame() {
        boardModel.reset()
        printBoard()
        isWinner = false
    }
    
    func printBoard() {
        var result = ""
        for row in boardModel.board {
            for column in row {
                result.append("\(column)\t\t")
            }
            result.append("\n")
        }
        boardVisualRepresentation = result
    }
}

struct BoardModel {
    var board: [[Int]] = []
    
    init() {
        reset()
    }
    
    mutating func reset() {
        let column: [Int] = Array(repeating: 0, count: 7)
        self.board = Array(repeating: column, count: 6)
    }
    
    mutating func dropPiece(column: Int, mark: Int, result: inout (row: Int, column: Int)) -> Bool {
        guard column < 7 && column >= 0 else { return false }
        
        for row in (0..<board.count).reversed() {
            if board[row][column] == 0 {
                board[row][column] = mark
                result = (row, column)
                return true
            }
        }
        return false
    }
    
}
