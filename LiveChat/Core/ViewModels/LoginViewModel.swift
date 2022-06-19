//
//  LoginViewModel.swift
//  LiveChat
//
//  Created by Богдан Зыков on 31.05.2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

class LoginViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var userName: String = ""
    @Published var imageData: ImageData?
    @Published var pass: String = ""
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var isloggedUser: Bool = false
    @Published var showLoader: Bool = false
    
    init(){
        DispatchQueue.main.async {
            self.checkLoginStatus()
        }
    }
    
    private func checkLoginStatus(){
        isloggedUser = FirebaseManager.shared.auth.currentUser?.uid != nil
    }

    
    public func login(){
        showLoader = true
        FirebaseManager.shared.auth.signIn(withEmail: email, password: pass) {[weak self] (result, error) in
            guard let self = self else {return}
            self.showLoader = false
            if let err = error{
                self.handleError(err, title: "Error login")
                self.showLoader = false
                return
            }
            withAnimation {
                self.checkLoginStatus()
            }
            print("Successfull login, \(result?.user.uid ?? "nil")")
            self.resetUserInfo()
        }
    }
    
    public func createAccount(){
        showLoader = true
        FirebaseManager.shared.auth.createUser(withEmail: email, password: pass) {[weak self] (result, error) in
            guard let self = self else {return}
            if let err = error{
                self.handleError(err, title: "Error create user")
                self.showLoader = false
                return
            }
            self.persistUserInfoToStorage{
                self.showLoader = false
                withAnimation {
                    self.checkLoginStatus()
                }
                print("Successfull create user, \(result?.user.uid ?? "nil")")
                self.resetUserInfo()
            }
        }
    }
    
    public func signOut(){
        DispatchQueue.main.async {
            try? FirebaseManager.shared.auth.signOut()
            withAnimation {
                self.checkLoginStatus()
            }
        }
    }

    
    private func persistUserInfoToStorage(completion: @escaping () -> Void){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        let imageUrl = uploadImage(ref: ref)
        storeUserInformation(imageUrl, completion: completion)
        
    }
    
    private func storeUserInformation(_ profileImageUrl: URL?, completion: @escaping () -> Void){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let userDate = ["uid": uid, "email": email, FBConstant.profileImageUrl: profileImageUrl?.absoluteString ?? "", FBConstant.name: userName]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userDate) { [weak self] (error) in
                guard let self = self else {return}
                if let err = error{
                    self.handleError(err, title: "")
                    return
                }
                completion()
            }
    }
    

    
    private func uploadImage(ref: StorageReference) -> URL?{
        var returnUrl: URL?
        guard let imageData = Helpers.preparingImageforUpload(imageData?.image) else {return nil}
        ref.putData(imageData, metadata: nil) { [weak self] (metadate, error) in
            guard let self = self else {return}
            self.handleError(error, title: "Error upload image:")
            ref.downloadURL {[weak self]  (url, error) in
                guard let self = self else {return}
                self.handleError(error, title: "Error load image url")
                returnUrl = url
            }
        }
        return returnUrl
    }
    
    
    private func handleError(_ error: Error?, title: String){
        Helpers.handleError(error, title: title, errorMessage: &errorMessage, showAlert: &showAlert)
    }
    private func resetUserInfo(){
        email = ""
        pass = ""
        userName = ""
        imageData = nil
    }
}
