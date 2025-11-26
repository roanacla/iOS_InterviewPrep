import Foundation

// Assuming CellState is accessible (e.g., in the same module or explicitly imported)
// enum CellState: Int, CaseIterable { ... } // Defined in BoardModel.swift

@Observable
class ConectedFourViewModel {
    var boardModel = BoardModel()
    // boardVisualRepresentation is no longer needed as the View will render visually
    var currentPlayer: CellState = .playerOne
    var isWinner: Bool = false
    var winner: CellState? = nil
    
    init() {
        // No need to printBoard() initially as the UI will render it
    }
    
    func dropDisk(in column: Int) {
        // Prevent dropping disks if there's already a winner
        guard !isWinner else { return }

        if let droppedPosition = boardModel.dropPiece(column: column, player: currentPlayer) {
            // No need to printBoard() here either
            
            if checkWinner(row: droppedPosition.row, column: droppedPosition.column, player: currentPlayer) {
                isWinner = true
                winner = currentPlayer
            } else {
                // Only switch player if no winner and piece was successfully dropped
                self.currentPlayer = (self.currentPlayer == .playerOne) ? .playerTwo : .playerOne
            }
        }
        // If dropPiece returns nil, the column was full or invalid.
        // You might want to add some UI feedback here later, e.g., a shake animation or an alert.
    }
    
    func checkWinner(row: Int, column: Int, player: CellState) -> Bool {
        let boardRows = boardModel.rows
        let boardColumns = boardModel.columns

        // Horizontal check
        var horizontalCounter = 0
        let leftScanEdge = max(0, column - 3)
        let rightScanEdge = min(boardColumns - 1, column + 3)
        for c in leftScanEdge...rightScanEdge {
            if boardModel.board[row][c] == player {
                horizontalCounter += 1
                if horizontalCounter >= 4 { return true }
            } else { horizontalCounter = 0 }
        }
        
        // Vertical check
        var verticalCounter = 0
        let topScanEdge = max(0, row - 3)
        let bottomScanEdge = min(boardRows - 1, row + 3)
        for r in topScanEdge...bottomScanEdge {
            if boardModel.board[r][column] == player {
                verticalCounter += 1
                if verticalCounter >= 4 { return true }
            } else { verticalCounter = 0 }
        }
        
        // Diagonal checks (top-left → bottom-right ↘️)
        for rOffset in 0..<(boardRows - 3) {
            for cOffset in 0..<(boardColumns - 3) {
                if boardModel.board[rOffset][cOffset] == player &&
                   boardModel.board[rOffset + 1][cOffset + 1] == player &&
                   boardModel.board[rOffset + 2][cOffset + 2] == player &&
                   boardModel.board[rOffset + 3][cOffset + 3] == player {
                    return true
                }
            }
        }

        // Diagonal checks (bottom-left → top-right ↗️)
        for rOffset in 3..<boardRows {
            for cOffset in 0..<(boardColumns - 3) {
                if boardModel.board[rOffset][cOffset] == player &&
                   boardModel.board[rOffset - 1][cOffset + 1] == player &&
                   boardModel.board[rOffset - 2][cOffset + 2] == player &&
                   boardModel.board[rOffset - 3][cOffset + 3] == player {
                    return true
                }
            }
        }
        
        return false
    }
    
    func resetGame() {
        boardModel.reset()
        // No need to printBoard() here
        isWinner = false
        winner = nil
        currentPlayer = .playerOne
    }
    
    // This function is likely no longer needed for UI but can remain for debugging if desired
    func printBoard() {
        var result = ""
        for row in boardModel.board {
            for cellState in row {
                result.append("\(cellState.rawValue)\t\t")
            }
            result.append("\n")
        }
        // boardVisualRepresentation = result // No longer assigning to a property
        print(result) // Print to console for debugging if needed
    }
}
