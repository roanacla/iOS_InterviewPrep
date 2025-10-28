//
//  SearchViewModel.swift
//  sample_movieSearch
//
//  Created by Roger Navarro Claros on 10/27/25.
//
import Foundation
import SwiftUI

enum SearchError: Error {
    case invalidResponse
    case invalidURL
    case errorDecoding
}

@Observable
class SearchViewModel {
    var search = Search()
    var searchText = ""
    var errorText = ""
    var showAlert = false
    
    func fetchSearch() async {
        do {
            searchText = searchText.isEmpty ? "Batman" : searchText
            let endPoint = "https://www.omdbapi.com/?apikey=40ecf6b5&s=\(searchText)"
            let url = URL(string: endPoint)
            guard url != nil else {
                throw SearchError.invalidURL
            }
            let request = URLRequest(url: url!)
        
            let (data, response) = try await URLSession.shared.data(for: request)
        
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200..<300).contains(statusCode) else {
                throw SearchError.invalidResponse
            }
        
            let search = try JSONDecoder().decode(Search.self, from: data)
            self.search = search
        } catch {
            showAlert = true
            if error is SearchError {
                switch (error as! SearchError) {
                    case .invalidResponse:
                    self.errorText = "Invalid response from the API"
                case .invalidURL:
                    self.errorText = "Invalid URL"
                case .errorDecoding:
                    self.errorText = "Error decoding the data"
                }
            } else {
                errorText = error.localizedDescription
            }
        }
    }
}
