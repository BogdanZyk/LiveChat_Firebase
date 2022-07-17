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
    @Published var userBio: String = ""
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
    
    private var isValidStep1: Bool {
        !email.isEmpty && !pass.isEmpty && pass == repeatPass
    }
    
    public func isValidSingUp( _ currentStep: Step) -> Bool{
        if currentStep == .step1{
            return isValidStep1
        }else{
            return isValidStep2
        }
    }
    
    private var isValidStep2: Bool {
        !userFirstName.isEmpty && !userName.isEmpty
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
    
    public func createAccount(completion: @escaping () -> Void){
        showLoader = true
        FirebaseManager.shared.auth.createUser(withEmail: email, password: pass) {[weak self] (result, error) in
            guard let self = self else {return}
            self.showLoader = false
            if let err = error{
                self.handleError(err, title: "Error create user")
                self.showLoader = false
                return
            }
            
            completion()
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

    
    public func persistUserInfoToStorage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        self.showLoader = true
        Helpers.uploadImageToFirestore(uiImage: imageData?.image, imagePath: imageData?.imageName ?? UUID().uuidString, path: "avatar_\(uid)") {[weak self] url, error in
            self?.storeUserInformation(url){[weak self] in
                self?.showLoader = false
                if let error = error {
                    self?.handleError(error, title: "Failde upload avatar")
                    return
                }
                withAnimation {
                    self?.checkLoginStatus()
                }
                self?.resetUserInfo()
            }
        }
    }
    
    private func storeUserInformation(_ profileImageUrl: URL?, completion: @escaping () -> Void){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let user = User(uid: uid, email: email, profileImageUrl: profileImageUrl?.absoluteString ?? "", userName: userName, firstName: userFirstName, lastName: "", bio: userBio, userBannerUrl: "", phone: "")
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
    

    
    private func uploadImageToFirestore(uiImage: UIImage?, imagePath: String, path: String, completion: @escaping (URL?, Error?) -> Void){
        let ref = FirebaseManager.shared.storage.reference().child(path).child(imagePath)
        guard let imageData = Helpers.preparingImageforUpload(uiImage) else {return completion(nil, nil)}
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
    
    
    private func handleError(_ error: Error?, title: String){
        Helpers.handleError(error, title: title, errorMessage: &errorMessage, showAlert: &showAlert)
    }
    private func resetUserInfo(){
        email = ""
        pass = ""
        repeatPass = ""
        userName = ""
        imageData = nil
    }
}
