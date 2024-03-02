//
//  CustomTextField.swift
//  RecipeApp
//
//  Created by Melon on 2/3/2024.
//

import SwiftUI

struct CustomTextFields: View {
    var title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.top)
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .frame(height: 100)
                    .foregroundColor(.white.opacity(0.5))
                    .border(Color(UIColor.separator), width: 0.5)
                TextField(title, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
            }
            .padding(.horizontal)
        }
    }
}


