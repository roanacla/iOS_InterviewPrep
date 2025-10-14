import SwiftUI

struct NetworkingView: View {
    let concept: Concept
    let song: Song
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .center) {
                Image(uiImage: artworkImage)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 200, height: 200)
                  .shadow(radius: 10)
                
                Text("Networking")
                    .font(.title2)
                    .bold()
            }
        }
        .padding()
        .navigationTitle(concept.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NetworkingView_Previews: PreviewProvider {
    static var previews: some View {
        let concept: Concept = .init(title: "Networking", description: "Fetching and sending data from and to a server", subject: .networking)
        NetworkingView(concept: concept)
    }
}
