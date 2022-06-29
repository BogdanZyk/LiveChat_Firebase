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
    @Published var showModalView: Bool = false
    @Published var email: String = ""
    @Published var repeatPass: String = ""
    @Published var userName: String = ""
    @Published var userFirstName: String = ""
    @Published var imageData: UIImageData?
    @Published var pass: String = ""
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var isloggedUser: Bool = false
    @Published var showLoader: Bool = false
    
    init(){
        self.checkLoginStatus()
    }
    
    private func checkLoginStatus(){
        isloggedUser = FirebaseManager.shared.auth.currentUser?.uid != nil
    }

    
    public var isValidEmailAndPass: Bool{
       !(email.isEmpty) && !(pass.isEmpty)
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
        let imageUrl = uploadUserAvatarImage(ref: ref)
        storeUserInformation(imageUrl, completion: completion)
        
    }
    
    private func storeUserInformation(_ profileImageUrl: URL?, completion: @escaping () -> Void){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let user = User(uid: uid, email: email, profileImageUrl: profileImageUrl?.absoluteString ?? "", name: userName)
        do {
            try  FirebaseManager.shared.firestore.collection("users")
                .document(uid).setData(from: user, completion: { error in
                    if let error = error{
                        self.handleError(error, title: "Filed to set user data")
                        return
                    }
                    completion()
                })
        } catch {
            handleError(error, title: "Filed to set user data")
        }
       
    }
    

    
    private func uploadUserAvatarImage(ref: StorageReference) -> URL?{
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
