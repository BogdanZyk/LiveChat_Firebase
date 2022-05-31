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
            self.handleError(error)
            print("Successfull create user, \(result?.user.uid ?? "nil")")
        }
    }
    
    public func createAccount(){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: pass) {[weak self] result, error in
            guard let self = self else {return}
            self.handleError(error)
            print("Successfull create user, \(result?.user.uid ?? "nil")")
        }
    }
    
    
    
    private func handleError(_ error: Error?){
        if let error = error {
            self.errorMessage = error.localizedDescription
            self.showAlert = true
        }
    }
}
