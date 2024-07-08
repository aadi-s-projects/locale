//
//  ImagePicker.swift
//  locale
//
//  Created by Sachin Gala on 7/7/24.
//

import SwiftUI
import PhotosUI

@MainActor
class ImagePicker: ObservableObject {
    @Published var image : Image?
    @Published var images : [Image] = []
    @Published var selectedUIImage : UIImage?
    @Published var selectedUIImages : [UIImage] = []
    @Published var imageSelection : PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }
    @Published var imageSelections : [PhotosPickerItem] = [] {
        didSet {
            Task {
                if !imageSelections.isEmpty{
                    try await loadTransferable(from: imageSelections)
                    imageSelections = []
                }
            }
        }
    }
    
    func loadTransferable(from imageSelections: [PhotosPickerItem]) async throws {
        do {
            images = []
            for imageSelection in imageSelections {
                if let data = try await imageSelection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        self.selectedUIImages.append(uiImage)
                        self.images.append(Image(uiImage: uiImage))
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.selectedUIImage = uiImage
                    self.image = Image(uiImage: uiImage)
                }
            }
        } catch {
            print(error.localizedDescription)
            image = nil
            selectedUIImage = nil
        }
    }
}
