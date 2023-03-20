//
//  ImagePicker.swift
//  Rio
//
//  Created by Andrea Tamez on 3/19/23.
//

import Foundation
import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    var onImagePicked: ((UIImage?) -> Void)?

    // Create the Coordinator for the ImagePicker
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Create a new UIImagePickerController with the specified source type
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }

    // Update the UIViewController (not needed in this case)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    // The Coordinator handles UIImagePickerControllerDelegate events
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // Handle image picker didFinishPickingMediaWithInfo event
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.onImagePicked?(image)
            } else {
                parent.onImagePicked?(nil)
            }
            picker.dismiss(animated: true)
        }

        // Handle image picker cancellation
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onImagePicked?(nil)
            picker.dismiss(animated: true)
        }
    }
}
