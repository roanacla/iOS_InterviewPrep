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
        Concept(title: "Connected Four",
                description: "A simple game to play connected Four",
                subject: .conectedFour),
        Concept(title: "UI Views with dynamic backgrounds",
                description: "A framework for processing values over time.",
                subject: .uiKitViews),
        Concept(title: "Group Calls by a criteria",
                description: "Similar to the recent lists",
                subject: .groupCalls),
        Concept(title: "Networking",
                description: "Fetching and sending data from and to a server.",
                subject: .networking),
        Concept(title: "Async Dictionary",
                description: "Fetching and sending data from and to a server.",
                subject: .networking),
        Concept(title: "Movie Search",
                description: "Searching movies from a server.",
                subject: .searchMovies),
        Concept(title: "Museum Search",
                description: "Searching objects from the MetMuseum from a server.",
                subject: .metMuseum),
        Concept(title: "Music Catalog",
                description: "Search over a catalog of artists and albums",
                subject: .musicCatalog )
        ]
}

enum Subject {
    case ticTacToe
    case uiKitViews
    case networking
    case groupCalls
    case conectedFour
    case searchMovies
    case metMuseum
    case musicCatalog
}

struct Concept: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let subject: Subject
}
