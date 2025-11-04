import SwiftUI

@MainActor
struct MetObjectsView: View {
    @State var objectsViewModel: ObjectsViewModel
    
    var body: some View {
        List($objectsViewModel.metObjects) { $metObject in
            VStack {
                NavigationLink {
                    MetObjectsDetailView(metObject: $metObject)
                } label: {
                    HStack {
                        VStack {
                            Text(metObject.title)
                            Text(metObject.isFavorite ? "★" : "☆")
                        }
                        Spacer()
                        if let url = URL(string: metObject.primaryImageSmall) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 70)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
        }
        .navigationTitle("The Met Objects")
        .searchable(text: $objectsViewModel.searchQuery)
        .onSubmit(of: .search) {
            Task {
                await objectsViewModel.searchObjects()
            }
        }
        .alert(
            "Error Fetching Objects",
            isPresented: $objectsViewModel.isErrorPresented
        ) {
            Button("OK") {
                // Handle the acknowledgement.
            }
        } message: {
            Text(objectsViewModel.alertMessage)
        }
        .overlay {
            if objectsViewModel.metObjects.isEmpty {
                ProgressView()
            }
        }
        .task {
            if !objectsViewModel.firstLoadReady {
                await objectsViewModel.searchObjects()
            }
        }
    }
}

#Preview {
    let viewModel = ObjectsViewModel(networkService: MetNetworkService())
    NavigationStack {
        MetObjectsView(objectsViewModel: viewModel)
    }
}
