import SwiftUI

struct MetObjectsDetailView: View {
//    @Bindable var selectedMetObject: MetObjectDetailViewModel
//    @State var title: String = ""
    @Binding var metObject: MetObject
    
    var body: some View {
        VStack(alignment: .center) {
            Text(metObject.title)
            Button(action: {
                metObject.toggleFavorite()
            }, label: {
                Text(metObject.isFavorite ? "★" : "☆")
                Text("Toggle Favorite")
            })
//            Text(selectedMetObject.metObject.title)
//            if let url = URL(string: selectedMetObject.metObject.primaryImage) {
//                AsyncImage(url: url) { image in
//                    image.image?
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 200, height: 300)
//                        .cornerRadius(8)
//                        .shadow(radius: 5)
//                }
//            }
//            TextField(text: $title, label: {
//                Text("Change title here:")
//            })
//            .frame(width: 500)
//            .onSubmit {
//                selectedMetObject.metObject.setTitle(title)
//            }
        }
//        .onAppear {
//            title = selectedMetObject.metObject.title
//        }
    }
}

#Preview {
//    MetObjectsDetailView(selectedMetObject: .init(metObject: MetObject(objectID: 1, title: "Hola", primaryImage: "", primaryImageSmall: "")), title: "asdf")
    @Previewable @State var metObject = MetObject(objectID: 1, title: "roger", primaryImage: "", primaryImageSmall: "")
    MetObjectsDetailView(metObject: $metObject)
}
