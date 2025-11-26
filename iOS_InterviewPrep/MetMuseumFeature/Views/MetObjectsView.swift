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
                        VStack(alignment: .leading) {
                            Text(metObject.title)
                            Spacer()
                            Text(metObject.isFavorite ? "★" : "☆")
                        }
                        Spacer()
                        if let cacheImage = objectsViewModel.nsCache.object(forKey: NSNumber(value: metObject.objectID)) {
                            Image(uiImage: cacheImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 70)
                                .fixedSize()
                        } else {
                            AsyncImage(url: URL(string: metObject.primaryImageSmall)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 70)// Displays the loaded image.
                                        .fixedSize()
                                } else if phase.error != nil {
                                    Color.red // Indicates an error.
                                } else {
                                    Color.blue // Acts as a placeholder.
                                }
                            }
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
