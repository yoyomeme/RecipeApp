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

    // Use this to programmatically focus the TextField
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.top)
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .foregroundColor(.white.opacity(0.5))
                    .border(Color(UIColor.separator), width: 0.5)
                    .onTapGesture {
                        // Focus the TextField when the Rectangle is tapped
                        self.isTextFieldFocused = true
                    }
                
                TextField(title, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .top) // Make TextField expand fully
                    .focused($isTextFieldFocused) // SwiftUI 3.0 and later
            }
            .padding(.horizontal)
        }
    }
}

struct CustomTextFields_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFields(title: "Name", text: .constant("John Doe"))
    }
}



