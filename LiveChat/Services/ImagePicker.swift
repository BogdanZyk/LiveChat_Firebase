//
//  ImagePicker.swift
//  LiveChat
//
//  Created by Богдан Зыков on 31.05.2022.
//

import SwiftUI


struct ImagePicker: UIViewControllerRepresentable{
    
    @Binding var imageData: UIImageData?
    
    private let controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        let parent: ImagePicker
         init(parent: ImagePicker) {
             self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            var imageName = UUID().uuidString
            if let url = info[.imageURL] as? URL{
                imageName = url.lastPathComponent
            }
            let image = info[.originalImage] as? UIImage
            parent.imageData = UIImageData(image: image, imageName: imageName)
            picker.dismiss(animated: true)
        }
        
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        return
    }
}

struct UIImageData{
    var image: UIImage?
    var imageName: String?
}
