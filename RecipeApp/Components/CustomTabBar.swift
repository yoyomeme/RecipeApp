//
//  CustomTabBar.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

// CustomTabBar.swift
import SwiftUI

struct CustomTabBar: View {
    @Binding var activeTab: Int

    var body: some View {
           HStack {
               Spacer()
               
               Button(action: {
                   activeTab = 0 // Set active tab to 1
               }) {
                   Image(systemName: "book.closed.fill")
                       .foregroundColor(activeTab == 0 ? .white : Color.gray.opacity(0.5)) // Change color for active tab
                       .background(activeTab == 0 ? .blue : Color.gray.opacity(0.5))
                       .cornerRadius(50)
                       .padding()
                       .scaleEffect(1.75)
               }
               
               Spacer()
               
               Button(action: {
                   activeTab = 1// Set active tab to 2
               }) {
                   Image(systemName: "plus.square.fill")
                       .foregroundColor(activeTab == 1 ? .white : Color.gray.opacity(0.5)) // Change color for active tab
                       .background(Color.blue.opacity(1))
                       .cornerRadius(50)
                       .padding()
                       .scaleEffect(1.75)
               }
               .padding(.vertical, 35)
               
               Spacer()
               
               Button(action: {
                   activeTab = 2 // Set active tab to 3
               }) {
                   Image(systemName: "gearshape.fill")
                       .foregroundColor(activeTab == 2 ? .white : Color.gray.opacity(0.5)) // Change color for active tab
                       .background(Color.blue.opacity(1))
                       .cornerRadius(50)
                       .padding()
                       .scaleEffect(1.75)
               }
               
               Spacer()
           }
           .background(Color.gray.opacity(0.5))
    }
}
