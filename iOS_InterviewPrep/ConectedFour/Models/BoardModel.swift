import Foundation

enum CellState: Int, CaseIterable {
    case empty = 0
    case playerOne = 1
    case playerTwo = 2 // Add more players if needed
}

struct BoardModel {
    private(set) var board: [[CellState]] // Use CellState and make board settable only within the struct
    let rows: Int
    let columns: Int

    init(rows: Int = 6, columns: Int = 7) {
        self.rows = rows
        self.columns = columns
        // Initialize with default empty state
        let emptyColumn: [CellState] = Array(repeating: .empty, count: columns)
        self.board = Array(repeating: emptyColumn, count: rows)
    }
    
    mutating func reset() {
        let emptyColumn: [CellState] = Array(repeating: .empty, count: columns)
        self.board = Array(repeating: emptyColumn, count: rows)
    }
    
    /// Drops a piece in the specified column for a given player.
    /// - Parameters:
    ///   - column: The column index (0-indexed) where the piece should be dropped.
    ///   - player: The CellState representing the player dropping the piece (e.g., .playerOne, .playerTwo).
    /// - Returns: An optional tuple `(row: Int, column: Int)` indicating the final position of the dropped piece if successful, otherwise `nil`.
    mutating func dropPiece(column: Int, player: CellState) -> (row: Int, column: Int)? {
        // Validate column input
        guard column >= 0 && column < columns else {
            return nil // Invalid column
        }
        
        // Iterate from the bottom row upwards to find the first empty spot
        for row in (0..<rows).reversed() {
            if board[row][column] == .empty {
                board[row][column] = player
                return (row, column) // Piece dropped successfully
            }
        }
        
        return nil // Column is full
    }
}
