//
//  RecipeCard.swift
//  RecipeApp
//
//  Created by Melon on 2/3/2024.
//

import SwiftUI

struct RecipeCard: View {
    var recipeName: String
    var imageURL: String
    
    // Refactored overlay text into a separate view
    private var overlayText: some View {
        Text(recipeName)
            .font(.headline)
            .foregroundColor(.white)
            .shadow(color: .black, radius: 2, x: 0, y: 0)
            .padding()
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay(alignment: .bottom) { overlayText }
                case .empty, .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40, alignment: .center)
                        .foregroundColor(.white.opacity(0.5))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay(alignment: .bottom) { overlayText }
                @unknown default:
                    EmptyView()
                }
            }
        }
        .frame(width: 160, height: 210, alignment: .top)
        .background(LinearGradient(gradient: Gradient(colors: [Color(.gray).opacity(0.2), Color(.gray)]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 10)
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(recipeName: "Pizza sample", imageURL: "https://example.com/image.jpg")
            .previewLayout(.sizeThatFits)
    }
}

//
//struct RemoteImageView: View {
//    var imageURL: String?
//    @State private var imageData: Data?
//
//    var body: some View {
//        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
//            Image(uiImage: uiImage)
//                .resizable()
//                .scaledToFit()
//        } else {
//            Image(systemName: "photo")
//                .resizable()
//                .scaledToFit()
//                .onAppear {
//                    fetchImage()
//                }
//        }
//    }
//
//    private func fetchImage() {
//        guard let imageURL = imageURL, let url = URL(string: imageURL) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                DispatchQueue.main.async {
//                    self.imageData = data
//                }
//            }
//        }.resume()
//    }
//}




//struct RecipeCard: View {
//    var recipeName: String
//    var imageURL: String?
//
//    var body: some View {
//        VStack {
//            RemoteImageView(imageURL: imageURL)
//                .frame(width: 150, height: 150)
//                .clipped()
//                .cornerRadius(10)
//                .shadow(radius: 5)
//
//            Text(recipeName)
//                .font(.headline)
//                .foregroundColor(.primary)
//                .lineLimit(1)
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(radius: 5)
//    }
//}
//
//struct RecipeCard_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeCard(recipeName: "Pizza sample", imageURL: "https://example.com/image.jpg")
//            .previewLayout(.sizeThatFits)
//    }
//}
//
//struct RemoteImageView: View {
//    var imageURL: String?
//    @State private var imageData: Data?
//
//    var body: some View {
//        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
//            Image(uiImage: uiImage)
//                .resizable()
//                .scaledToFit()
//        } else {
//            Image(systemName: "photo")
//                .resizable()
//                .scaledToFit()
//                .onAppear {
//                    fetchImage()
//                }
//        }
//    }
//
//    private func fetchImage() {
//        guard let imageURL = imageURL, let url = URL(string: imageURL) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                DispatchQueue.main.async {
//                    self.imageData = data
//                }
//            }
//        }.resume()
//    }
//}
