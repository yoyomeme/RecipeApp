//
//  ViewModelState.swift
//  RecipeApp
//
//  Created by Melon on 2/3/2024.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var isShowingViewB: Bool = false
}

