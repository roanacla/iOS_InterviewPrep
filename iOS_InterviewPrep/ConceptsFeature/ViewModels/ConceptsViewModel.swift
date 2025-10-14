//
//  ConceptsViewModel.swift
//  iOS_InterviewPrep
//
//  Created by Roger Navarro Claros on 10/13/25.
//

// Create an observed object to hold the logic of conceptsView
import SwiftUI

@Observable
class ConceptsViewModel {
    var concepts: [Concept] = [
        Concept(title: "Tic Tac Toe",
                description: "A simple game to play tic tac toe",
                subject: .ticTacToe),
        Concept(title: "UI Views with dynamic backgrounds",
                description: "A framework for processing values over time.",
                subject: .uiKitViews),
        Concept(title: "Networking",
                description: "Fetching and sending data from and to a server.",
                subject: .networking)
        ]
}

enum Subject {
    case ticTacToe
    case uiKitViews
    case networking
}

struct Concept: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let subject: Subject
}
