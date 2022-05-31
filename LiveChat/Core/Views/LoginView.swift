//
//  ContentView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 31.05.2022.
//

import SwiftUI

struct LoginView: View {
    @State private var isLogin: Bool = false
    @State private var showImagePicker: Bool = false
    @StateObject private var loginVM = LoginViewModel()
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    picker
                    if !isLogin{
                        avatarButton
                    }
                    inputSection
                }
                .padding(.horizontal)
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle(isLogin ? "Login" : "Create Account")
            .alert("", isPresented: $loginVM.showAlert) {
                Button("Ok", role: .cancel, action: {})
            } message: {
                Text(loginVM.errorMessage)
            }
            .sheet(isPresented: $showImagePicker, onDismiss: nil) {
                ImagePicker(image: $loginVM.userAvatar)
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension LoginView{
    private var picker: some View{
        Picker(selection: $isLogin) {
            Text("Login")
                .tag(true)
            Text("Create Account")
                .tag(false)
        } label: {
            Text("")
        }
        .pickerStyle(.segmented)
    }
    private var avatarButton: some View{
        Button {
            showImagePicker = true
        } label: {
            VStack{
                if let image = loginVM.userAvatar{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                }else{
                    Image(systemName: "person.fill")
                        .font(.system(size: 64))
                        .padding()
                        .foregroundColor(.black)
                }
            }
        }
    }
    private var inputSection: some View{
        VStack(alignment: .leading, spacing: 20) {
            Group{
                TextField("Email", text: $loginVM.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.none)
                SecureField("Password", text: $loginVM.pass)
            }
            .padding(12)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            loginOrCreateAcc
                .padding(.top, 20)
        }
    }
    
    private var loginOrCreateAcc: some View{
        Button {
            handleAction()
        } label: {
            HStack{
                Text(isLogin ? "Login" : "Create Account")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue, in: RoundedRectangle(cornerRadius: 10))
        }

    }
    private func handleAction(){
        if isLogin{
            loginVM.login()
        }else{
            loginVM.createAccount()
        }
    }
}
