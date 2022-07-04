//
//  ContentView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 31.05.2022.
//

import SwiftUI

struct LoginView: View {
    @Binding var showLoginView: Bool
    @EnvironmentObject private var loginVM: LoginViewModel
    var body: some View {
        ZStack{
            Color.bgWhite.ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            VStack(spacing: 10) {
                navTitle
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 40){
                        inputSection
                        Divider()
                        socialButtonView
                    }
                }
                loginActionButtons
            }
            .padding(.horizontal, 20)
            .foregroundColor(.fontPrimary)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showLoginView: .constant(false))
            .environmentObject(LoginViewModel())
    }
}

extension LoginView{
    private var navTitle: some View{
        Text("Log In")
            .font(.urbMedium(size: 20))
            .padding(.bottom, 10)
    }
    private var inputSection: some View{
        VStack(alignment: .leading, spacing: 20) {
            TextFieldViewComponent(text: $loginVM.email, promt: "Email Address", font: .urbMedium(size: 16), height: 55)
            TextFieldViewComponent(text: $loginVM.pass, promt: "Password", font: .urbMedium(size: 16), height: 55, isSecureTF: true)
            forgotPassButton
        }
        .padding(.top,20)
    }
    private var forgotPassButton: some View{
        Button {
            
        } label: {
            Text("Forgot Password?")
                .font(.urbMedium(size: 16))
        }
    }
    private var socialButtonView: some View{
        VStack(alignment: .leading, spacing: 20) {
            SocialButton(isGoogleBtn: true, action: {})
            SocialButton(isGoogleBtn: false, action: {})
        }
    }
    private var loginActionButtons: some View{
        VStack(alignment: .leading, spacing: 20) {
            if loginVM.showLoader{
                ProgressLoader()
                    .frame(height: 50)
                    .hCenter()
            }else{
                CustomButtomView(title: "Log In", isDisabled: !loginVM.isValidEmailAndPass) {
                    loginVM.login()
                }
            }
            HStack(spacing: 5) {
                Text("Don’t have an account?")
                Button {
                    withAnimation {
                        showLoginView = false
                    }
                } label: {
                    Text("Sign Up")
                        .foregroundColor(.accentBlue)
                }
            }
            .font(.urbMedium(size: 16))
            .hCenter()
        }
        .padding(.bottom, 10)
    }
}
