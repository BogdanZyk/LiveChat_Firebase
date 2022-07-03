//
//  EditProfileViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 03.07.2022.
//

import Foundation


class EditProfileViewModel: ObservableObject{
    
    @Published var showLoaderView: Bool = false
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var userAvatar: UIImageData?
    @Published var currentUser: User = User(uid: "", email: "", profileImageUrl: "", userName: "", firstName: "", lastName: "", bio: "", userBannerUrl: "", phone: "")
    
    
    
    
    
    public func updateUserInfo(completion: @escaping () -> Void){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        showLoaderView = true
        let userDoc = FirebaseManager.shared.firestore.collection("users")
            .document(uid)
        uploadUserAvatar(uid: uid) { [weak self] url in
            guard let self = self else {return}
            
            var userData: [AnyHashable : Any] = [
                "userName": self.currentUser.userName,
                "firstName": self.currentUser.firstName,
                "lastName": self.currentUser.lastName,
                "bio": self.currentUser.bio,
                "phone": self.currentUser.phone
            ]
            
            if let url = url?.absoluteString{
                userData.updateValue(url, forKey: "profileImageUrl")
            }
            
            userDoc.updateData(userData) { error in
                self.showLoaderView = false
                if let error = error{
                Helpers.handleError(error, title: "Failed update user info", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                    return
                }
                completion()
            }
        }
    }
    
    
    private func uploadUserAvatar(uid: String, completion: @escaping (URL?) -> Void){
        Helpers.uploadImageToFirestore(uiImage: userAvatar?.image, imagePath: userAvatar?.imageName ?? UUID().uuidString, path: "avatar_\(uid)") {[weak self] (url, error) in
            guard let self = self else {
                completion(nil)
                return
            }
            if let error = error {
                Helpers.handleError(error, title: "Failed upload user avatar", errorMessage: &self.errorMessage, showAlert: &self.showAlert)
                    return
            }
            completion(url)
        }
    }
}
