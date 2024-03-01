//
//  ImageSelection.swift
//  RecipeApp
//
//  Created by Melon on 1/3/2024.
//

import SwiftUI
import PhotosUI

struct ImageSelection: View {
    @Binding var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isShowingCamera = false
    @State private var photosPickerPresented = false
    @State private var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            
            // Image preview section
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .foregroundColor(.gray)
            }
            
            // Action buttons to select from library or take a photo
            HStack {
                Button("Library") {
                    photosPickerPresented = true
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                Text("Please upload an image")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                
                Button("Camera") {
                    isShowingCamera = true
                }
                .frame(maxWidth: .infinity)
            }
            
        }
        .photosPicker(
            isPresented: $photosPickerPresented,
            selection: $photoPickerItem,
            matching: .images
        )
        .onChange(of: photoPickerItem) { newItem in
            Task {
                // Load the selected image
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImage = UIImage(data: data)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            Camera(isPresented: $isShowingCamera, selectedImage: $selectedImage)
        }
    }
}
