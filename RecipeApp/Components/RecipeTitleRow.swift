//
//  RecipeTitleRow.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI

struct RecipeTitleRow: View {
    @State private var showingUpdateSheet = false
    
    var title: String
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title).bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading)
    }
}

struct RecipeTitleRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTitleRow(title: "Recipe")
            .background(LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.orange.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}
