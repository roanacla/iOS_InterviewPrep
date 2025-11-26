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

// MARK: - DiskView (New Component for individual disks)
struct DiskView: View {
    let cellState: CellState
    let row: Int // Used to calculate the initial drop height
    let cellSize: CGFloat
    
    // State for managing the disk's vertical offset during animation
    @State private var dropYOffset: CGFloat
    @State private var opacity: Double

    // Custom initializer to set initial @State values based on props
    init(cellState: CellState, row: Int, cellSize: CGFloat) {
        self.cellState = cellState
        self.row = row
        self.cellSize = cellSize
        
        // Calculate initial Y offset for the drop animation.
        // Higher rows start higher up. `cellSize + 8` accounts for cell size plus spacing.
        _dropYOffset = State(initialValue: -CGFloat(row) * (cellSize + 8) - cellSize)
        _opacity = State(initialValue: 0.0) // Start invisible
    }

    var body: some View {
        Circle()
            .fill(cellState.color)
            .frame(width: cellSize, height: cellSize)
            .shadow(color: .black.opacity(0.4), radius: 3, x: 2, y: 2) // Shadow for the disk itself
            .offset(y: dropYOffset) // Apply the animated offset
            .opacity(opacity) // Apply opacity for fade-in
            .onAppear {
                // Animate to landing position with a spring effect
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.2)) {
                    dropYOffset = 0 // Land at its final position
                    opacity = 1.0 // Become fully visible
                }
            }
            // `id(cellState)` ensures onAppear is re-triggered if the disk's state changes
            // (e.g., when a disk is placed or the board is reset and a new disk appears).
            .id(cellState) 
    }
}

// MARK: - ConectedFourView
struct ConectedFourView: View {
    @State var viewModel: ConectedFourViewModel = .init()

    // Constants for cell sizing and spacing
    private let cellSize: CGFloat = 50
    private let spacing: CGFloat = 8

    // Helper to calculate board dimensions for consistent sizing
    private var boardWidth: CGFloat { CGFloat(viewModel.boardModel.columns) * (cellSize + spacing) + spacing }
    private var boardHeight: CGFloat { CGFloat(viewModel.boardModel.rows) * (cellSize + spacing) + spacing }

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

            // MARK: The Game Board Display (composed of layers)
            ZStack {
                // LAYER A: The very back blue board background
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue)
                    .frame(width: boardWidth, height: boardHeight)
                    .shadow(radius: 8, x: 0, y: 5) // Deeper shadow for the board itself

                // MIDDLE LAYER: All the player disks
                VStack(spacing: spacing) {
                    ForEach(0..<viewModel.boardModel.rows, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<viewModel.boardModel.columns, id: \.self) { column in
                                if viewModel.boardModel.board[row][column] != .empty {
                                    DiskView(cellState: viewModel.boardModel.board[row][column],
                                             row: row,
                                             cellSize: cellSize)
                                } else {
                                    // Placeholder for empty cells to maintain grid layout for disk layer
                                    Color.clear
                                        .frame(width: cellSize, height: cellSize)
                                }
                            }
                        }
                    }
                }
                .padding(spacing / 2) // Align the grid of disks with the holes

                // LAYER B: The top blue board with transparent holes and their visual details
                Group {
                    // Part 1: The blue board with actual transparent holes cut out using a mask
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue)
                        .frame(width: boardWidth, height: boardHeight)
                        .shadow(radius: 8, x: 0, y: 5) // Shadow for the upper part of the board
                        .mask(
                            // The mask creates transparent circles.
                            // Opaque areas in the mask allow the content (blue rectangle) to show.
                            // Transparent areas in the mask make the content transparent.
                            Rectangle()
                                .fill(Color.black) // Start with an opaque rectangle
                                .overlay(
                                    VStack(spacing: spacing) {
                                        ForEach(0..<viewModel.boardModel.rows, id: \.self) { _ in
                                            HStack(spacing: spacing) {
                                                ForEach(0..<viewModel.boardModel.columns, id: \.self) { _ in
                                                    Circle()
                                                        .frame(width: cellSize, height: cellSize)
                                                        .blendMode(.destinationOut) // Cuts out the circles, making them transparent in the mask
                                                }
                                            }
                                        }
                                    }
                                    .padding(spacing / 2) // Align mask holes with the grid
                                )
                        )

                    // Part 2: The visual appearance of the holes (gray fill, stroke, and now inner shadow)
                    VStack(spacing: spacing) {
                        ForEach(0..<viewModel.boardModel.rows, id: \.self) { row in
                            HStack(spacing: spacing) {
                                ForEach(0..<viewModel.boardModel.columns, id: \.self) { column in
                                    
                                    // Refactored for inner shadow effect
                                    ZStack {
                                        // 1. Inner shadow layer: A slightly offset, blurred dark circle
                                        Circle()
                                            .fill(Color.black.opacity(0.7)) // Shadow color
                                            .offset(x: 1, y: 2) // Adjust offset for desired shadow direction
                                            .blur(radius: 4) // Soften the shadow
                                            .compositingGroup() // Ensures correct interaction with clipShape

                                        // 2. Main fill of the hole: Transparent gray circle
                                        Circle()
                                            .fill(Color.gray.opacity(0.4)) // The visual fill of the hole
                                    }
                                    .frame(width: cellSize, height: cellSize) // Apply frame to the ZStack
                                    .clipShape(Circle()) // Clip the entire ZStack (shadow + fill) to the circle
                                    .overlay(
                                        // 3. The outer stroke for definition
                                        Circle()
                                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                    .padding(spacing / 2) // Align visual holes with the board and disks
                }
            } // End of ZStack for board visuals
            .frame(width: boardWidth, height: boardHeight) // Ensure the ZStack itself has a fixed size
            .contentShape(Rectangle()) // Make the entire ZStack tappable
            .gesture(
                SpatialTapGesture()
                    .onEnded { event in
                        // `event.location` is relative to this ZStack.
                        // The grid within the board is offset by `spacing / 2` from the edges of the board.
                        let adjustedX = event.location.x - (spacing / 2)
                        let columnSlotWidth = cellSize + spacing
                        let tappedColumn = Int(adjustedX / columnSlotWidth)
                        
                        if tappedColumn >= 0 && tappedColumn < viewModel.boardModel.columns && !viewModel.isWinner {
                            viewModel.dropDisk(in: tappedColumn)
                        }
                    }
            )
            .animation(.easeOut(duration: 0.4), value: viewModel.boardModel.board) // This animation applies to changes within the ZStack
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
}

#Preview {
    ConectedFourView(viewModel: .init())
}
