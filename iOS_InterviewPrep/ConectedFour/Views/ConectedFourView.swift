import SwiftUI

// Helper for cell state colors, remains the same
extension CellState {
    var color: Color {
        switch self {
        case .empty: return .clear
        case .playerOne: return .red
        case .playerTwo: return .yellow
        }
    }
    
    var description: String {
        switch self {
        case .empty: return "Empty"
        case .playerOne: return "Player 1 (Red)"
        case .playerTwo: return "Player 2 (Yellow)"
        }
    }
}

struct ConectedFourView: View {
    @State var viewModel: ConectedFourViewModel = .init()

    // Constants for cell sizing and spacing
    private let cellSize: CGFloat = 50
    private let spacing: CGFloat = 8

    var body: some View {
        VStack {
            // MARK: Game Status Display
            Text(viewModel.winner != nil ? "Winner: \(viewModel.winner?.description ?? "Unknown")!" : "Current Turn: \(viewModel.currentPlayer.description)")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(viewModel.winner?.color ?? .primary) // Use color from CellState extension
                .animation(.easeInOut, value: viewModel.winner)
            
            Spacer()

            // MARK: The Game Board Display (now tappable)
            ZStack {
                // The main board frame/background
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue) // Classic blue Connect Four board color
                    .frame(width: CGFloat(viewModel.boardModel.columns) * (cellSize + spacing) + spacing,
                           height: CGFloat(viewModel.boardModel.rows) * (cellSize + spacing) + spacing)
                    .shadow(radius: 8, x: 0, y: 5) // Deeper shadow for the board itself
                    .contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { event in
                                let columnSlotWidth = cellSize + spacing
                                let adjustedX = event.location.x - spacing
                                let tappedColumn = Int(adjustedX / columnSlotWidth)
                                
                                if tappedColumn >= 0 && tappedColumn < viewModel.boardModel.columns && !viewModel.isWinner {
                                    viewModel.dropDisk(in: tappedColumn)
                                }
                            }
                    )

                // Grid of pieces and 'holes' - these are visual elements rendered on top of the background
                VStack(spacing: spacing) {
                    ForEach(0..<viewModel.boardModel.rows, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<viewModel.boardModel.columns, id: \.self) { column in
                                CellView(cellState: viewModel.boardModel.board[row][column],
                                         row: row, // Pass row for animation calculation
                                         cellSize: cellSize)
                            }
                        }
                    }
                }
            }
            .animation(.easeOut(duration: 0.4), value: viewModel.boardModel.board) // Animate changes to the board
            .padding(.horizontal)
            .padding(.vertical, 10)

            Spacer()

            // MARK: Reset Game Button
            Button("Reset Game") {
                viewModel.resetGame()
            }
            .font(.title3)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding(.bottom)
        }
        .padding()
    }

    // MARK: - Nested CellView for individual board cells and animation
    struct CellView: View {
        let cellState: CellState
        let row: Int // Used to calculate the initial drop height
        let cellSize: CGFloat
        
        // State for managing the disk's vertical offset during animation
        @State private var dropYOffset: CGFloat = -100 // Start high above the cell
        @State private var opacity: Double = 0.0 // Start invisible

        var body: some View {
            ZStack {
                // The 'hole' appearance
                Circle()
                    .fill(Color.gray.opacity(0.4)) // Slightly darker for more depth
                    .frame(width: cellSize, height: cellSize)
                    .shadow(color: .black.opacity(0.7), radius: 3, x: 0, y: 2) // Inner shadow effect for the hole
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 1) // Outline for more definition
                    )

                // The actual player piece, visible only if the cell is not empty
                if cellState != .empty {
                    Circle()
                        .fill(cellState.color)
                        .frame(width: cellSize, height: cellSize)
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 2, y: 2) // Shadow for the disk
                        .offset(y: dropYOffset) // Apply the animated offset
                        .opacity(opacity) // Apply opacity for fade-in
                        .onAppear {
                            // Calculate a realistic drop start position based on the row
                            // This makes higher rows fall shorter distances
                            let initialFallDistance = -CGFloat(row) * (cellSize + 8) - cellSize // 8 is the spacing
                            
                            // Initialize off-screen and invisible
                            dropYOffset = initialFallDistance
                            opacity = 0.0

                            // Animate to landing position with a spring effect
                            // The spring parameters (response, dampingFraction) control the bounce
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.2)) {
                                dropYOffset = 0 // Land at its final position
                                opacity = 1.0 // Become fully visible
                            }
                        }
                        // Reset animation state when piece changes (e.g., on reset game)
                        .id(cellState) // Ensure onAppear is re-triggered if state changes (e.g., reset)
                }
            }
        }
    }
}

#Preview {
    ConectedFourView(viewModel: .init())
}
