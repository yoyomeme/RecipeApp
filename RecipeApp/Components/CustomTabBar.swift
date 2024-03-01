//
//  CustomTabBar.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI

struct CustomTabBar: View {
    @State private var activeTab: Int = 1 // Track the active tab
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                activeTab = 1 // Set active tab to 1
            }) {
                Image(systemName: "1.circle.fill")
                    .foregroundColor(activeTab == 1 ? .white : Color.gray.opacity(0.5)) // Change color for active tab
                    .background(activeTab == 1 ? .blue : Color.gray.opacity(0.5))
                    .cornerRadius(50)
                    .padding()
                    .scaleEffect(1.75)
            }
            
            Spacer()
            
            Button(action: {
                activeTab = 2 // Set active tab to 2
            }) {
                Image(systemName: "2.circle.fill")
                    .foregroundColor(activeTab == 2 ? .white : Color.gray.opacity(0.5)) // Change color for active tab
                    .background(Color.blue.opacity(1))
                    .cornerRadius(50)
                    .padding()
                    .scaleEffect(1.75)
            }
            .padding(.vertical, 35)
            
            Spacer()
            
            Button(action: {
                activeTab = 3 // Set active tab to 3
            }) {
                Image(systemName: "3.circle.fill")
                    .foregroundColor(activeTab == 3 ? .white : Color.gray.opacity(0.5)) // Change color for active tab
                    .background(Color.blue.opacity(1))
                    .cornerRadius(50)
                    .padding()
                    .scaleEffect(1.75)
            }
            
            Spacer()
        }
        .background(Color.gray.opacity(0.5))
        //.foregroundColor(.white)
        
    }
}
