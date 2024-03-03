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

    // Use this to programmatically focus the TextEditor
    @FocusState private var isTextEditorFocused: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.top)
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(title)
                        .foregroundColor(Color(UIColor.placeholderText)) // Placeholder style
                        .padding(10)
                }
                
                TextEditor(text: $text)
                    .opacity(text.isEmpty ? 0.25 : 1) // Adjust opacity to hint at the placeholder
                    //.padding(10)
                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .top) // Make TextEditor expand fully
                    .background(Rectangle().foregroundColor(.white.opacity(0.5)).border(Color(UIColor.separator), width: 0.5))
                    .focused($isTextEditorFocused) // SwiftUI 3.0 and later
            }
            .onTapGesture {
                // Focus the TextEditor when the ZStack is tapped
                self.isTextEditorFocused = true
            }
            .padding(.horizontal)
        }
    }
}

struct CustomTextFields_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFields(title: "Description", text: .constant(""))
    }
}



