import SwiftUI

@MainActor
struct MetObjectsView: View {
    @State var objectsViewModel: ObjectsViewModel
    
    var body: some View {
        List(objectsViewModel.metObjects) { metObject in
            VStack {
                NavigationLink {
                    Text(metObject.title)
                } label: {
                    HStack {
                        Text(metObject.title)
                        Spacer()
                        AsyncImage(url: URL(string: metObject.primaryImageSmall)) { image in
                            image.image?
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 70)
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
            await objectsViewModel.searchObjects()
        }
    }
}

#Preview {
    let viewModel = ObjectsViewModel(networkService: MetNetworkService())
    NavigationStack {
        MetObjectsView(objectsViewModel: viewModel)
    }
}
