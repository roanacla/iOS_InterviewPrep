import Foundation

enum CellState: Int, CaseIterable {
    case empty = 0
    case playerOne = 1
    case playerTwo = 2 // Add more players if needed
}

struct BoardModel {
    private(set) var board: [[CellState]]
    let rows: Int
    let columns: Int

    init(rows: Int = 6, columns: Int = 7) {
        self.rows = rows
        self.columns = columns
        let emptyColumn: [CellState] = Array(repeating: .empty, count: columns)
        self.board = Array(repeating: emptyColumn, count: rows)
    }
    
    mutating func reset() {
        let emptyColumn: [CellState] = Array(repeating: .empty, count: columns)
        self.board = Array(repeating: emptyColumn, count: rows)
    }
    
    /// Previews where a piece would drop in the specified column without actually placing it.
    /// - Parameter column: The column index (0-indexed).
    /// - Returns: An optional tuple `(row: Int, column: Int)` indicating the target position if possible, otherwise `nil`.
    func previewDropPiece(column: Int) -> (row: Int, column: Int)? {
        guard column >= 0 && column < columns else {
            return nil // Invalid column
        }
        
        for row in (0..<rows).reversed() {
            if board[row][column] == .empty {
                return (row, column) // Found the lowest empty spot
            }
        }
        
        return nil // Column is full
    }
    
    /// Places a piece at a specific row and column on the board.
    /// This function is intended to be called after an animation has completed.
    /// - Parameters:
    ///   - row: The row index (0-indexed).
    ///   - column: The column index (0-indexed).
    ///   - player: The CellState representing the player's piece.
    mutating func setPiece(row: Int, column: Int, player: CellState) {
        guard row >= 0 && row < rows && column >= 0 && column < columns else {
            print("Attempted to set piece at invalid coordinates: (\(row), \(column))")
            return
        }
        board[row][column] = player
    }

    /// Drops a piece into the specified column for the given player.
    /// - Parameters:
    ///   - column: The column index (0-indexed) where the piece should be dropped.
    ///   - player: The CellState representing the player dropping the piece.
    /// - Returns: An optional tuple `(row: Int, column: Int)` indicating the final position of the dropped piece if successful, otherwise `nil` (e.g., if the column is full or invalid).
    mutating func dropPiece(column: Int, player: CellState) -> (row: Int, column: Int)? {
        if let targetPosition = previewDropPiece(column: column) {
            setPiece(row: targetPosition.row, column: targetPosition.column, player: player)
            return targetPosition
        }
        return nil // Column is full or invalid
    }
}
