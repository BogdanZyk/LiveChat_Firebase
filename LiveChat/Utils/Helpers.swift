//
//  Helpers.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//


import Firebase
import SwiftUI

final class Helpers{
    
    
    static func handleError(_ error: Error?, title: String, errorMessage: inout String, showAlert: inout Bool){
        if let error = error {
            errorMessage = "\(title) \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    static func decodeUserData(_ snapshot: DocumentSnapshot?) -> User?{
        guard let data = snapshot?.data() else {return nil}
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else{return nil}
        return try? JSONDecoder().decode(User.self, from: jsonData)
    }
    
    static func getRoomUid(toId: String, fromId: String) -> String{
        toId > fromId ? (fromId + toId) : (toId + fromId)
    }
    
    
    
    static func preparingImageforUpload(_ image: UIImage?, compressionQuality: CGFloat = 0.9) -> Data?{
        guard let image = image, let imageData = image.jpegData(compressionQuality: compressionQuality) else {return nil}
        return imageData
    }
    
    static func uploadImageToFirestore(uiImage: UIImage?, imagePath: String, path: String, completion: @escaping (URL?, Error?) -> Void){
        guard let uiImage = uiImage else {
            completion(nil, nil)
            return
        }
        let ref = FirebaseManager.shared.storage.reference().child(path).child(imagePath)
        guard let imageData = preparingImageforUpload(uiImage) else {return}
        ref.putData(imageData, metadata: nil) {(metadate, error) in
            if let error = error{
                completion(nil, error)
            }
            
//            self.handleError(error, title: "Error upload image:")
            ref.downloadURL {(url, error) in
                if let error = error{
                    completion(nil, error)
                    return
                }
                //self.handleError(error, title: "Error load image url")
                completion(url, nil)
            }
        }
    }
    

}
