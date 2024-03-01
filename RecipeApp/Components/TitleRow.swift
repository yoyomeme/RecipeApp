//
//  TitleRow.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI

struct TitleRow: View {
    @State private var showingUpdateSheet = false
    
    var profileUrl: URL?
    var profileName: String
    var availability: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: profileUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView() // Displayed while loading
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .cornerRadius(50)
                case .failure:
                    Image(systemName: "person.fill") // Fallback image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .cornerRadius(50)
                        .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 0))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text(profileName)
                    .font(.title2).bold()
                Text(availability ? "Online" : "Offline")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button(action: {
                showingUpdateSheet.toggle()
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24)) // Set the size of the SF Symbol
                    .foregroundColor(.gray)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(50)
            }
            .sheet(isPresented: $showingUpdateSheet) {
                UpdateUserDetails(profileUrl: profileUrl, profileName: profileName, availability: availability)
            }
        }
        .padding()
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow(profileUrl: URL(string: "https://example.com/profile.jpg"), profileName: "Phoebe", availability: true)
            .background(LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.orange.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}
