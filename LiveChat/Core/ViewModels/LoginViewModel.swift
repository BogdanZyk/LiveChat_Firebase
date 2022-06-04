//
//  LoginViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 31.05.2022.
//

import SwiftUI



class LoginViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var userAvatar: UIImage?
    @Published var pass: String = ""
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    
    
    
    
    public func login(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: pass) {[weak self] result, error in
            guard let self = self else {return}
            self.handleError(error, title: "Error login")
            print("Successfull login, \(result?.user.uid ?? "nil")")
        }
    }
    
    public func createAccount(){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: pass) {[weak self] result, error in
            guard let self = self else {return}
            self.handleError(error, title: "Error create user")
            self.persistImageToStorage()
            print("Successfull create user, \(result?.user.uid ?? "nil")")
        }
    }
    
    private func persistImageToStorage(){
//        let fileName = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let image = self.userAvatar?.jpegData(compressionQuality: 0.9) else {return}
        ref.putData(image, metadata: nil) { [weak self] (metadate, error) in
            guard let self = self else {return}
            self.handleError(error, title: "Error upload image:")
            ref.downloadURL {[weak self]  (url, error) in
                guard let self = self else {return}
                self.handleError(error, title: "Error load image url")
                self.storeUserInformation(url)
            }
        }
    }
    
    private func storeUserInformation(_ profileImageUrl: URL?){
        guard let profileImageUrl = profileImageUrl else {return}
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let userDate = ["uid": uid, "email": self.email, "profileImageUrl": profileImageUrl.absoluteString]
        
        FirebaseManager.shared.firestore.collection("user")
            .document(uid).setData(userDate) { [weak self] (error) in
                guard let self = self else {return}
                if let err = error{
                    self.handleError(err, title: "")
                    return
                }
                print("success store user!")
            }
    }
    
    private func handleError(_ error: Error?, title: String){
        if let error = error {
            self.errorMessage = "\(title) \(error.localizedDescription)"
            self.showAlert = true
        }
    }
}
