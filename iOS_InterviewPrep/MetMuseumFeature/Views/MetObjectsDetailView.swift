import SwiftUI

struct MetObjectsDetailView: View {
    @State var viewModel: MetObjectDetailViewModel
    @Binding var metObject: MetObject
    
    var body: some View {
        VStack(alignment: .center) {
            if let url = URL(string: metObject.primaryImage) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 300)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                } placeholder: {
                    let id = NSNumber(value: metObject.objectID)
                    if let uiImage = viewModel.nsCache.object(forKey: id) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 300)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    }
                }
            } else {
                let id = NSNumber(value: metObject.objectID)
                if let uiImage = viewModel.nsCache.object(forKey: id) {
                    Image(uiImage: uiImage)
                }
            }
            Text(metObject.title)
                .padding()
            Button(action: {
                metObject.toggleFavorite()
            }, label: {
                Text(metObject.isFavorite ? "★" : "☆")
                    .font(.system(size: 30))
            })
        }
    }
}

#Preview {
    @Previewable @State var metObject = MetObject(objectID: 1, title: "roger", primaryImage: "https://images.metmuseum.org/CRDImages/eg/web-large/LC-04_2_479_EGDP030848.jpg", primaryImageSmall: "")
    MetObjectsDetailView(viewModel: .init(metObject: metObject, cache: NSCache<NSNumber, UIImage>()), metObject: $metObject)
}
