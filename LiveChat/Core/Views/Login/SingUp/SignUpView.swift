//
//  SignUpView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 29.06.2022.
//

import SwiftUI

struct SignUpView: View {
    @Binding var showLoginView: Bool
    @EnvironmentObject var loginVM: LoginViewModel
    @State private var currentStep: Step = .step1
    @State private var showImagePicker: Bool = false
    var body: some View {
        ZStack {
            Color.bgWhite.ignoresSafeArea()
            VStack(spacing: 10) {
                navTitle
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 40){
                       
                        if currentStep == .step1{
                            step1
                                .transition(.move(edge: .leading))
                        }else if currentStep == .step2{
                            step2
                                .transition(.move(edge: .leading))
                        }
                  
                    }
                }
                bottomButtons
            }
            .padding(.horizontal, 20)
            .foregroundColor(.fontPrimary)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .sheet(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(imageData: $loginVM.imageData)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showLoginView: .constant(true))
            .previewDevice("iPhone 13")
            .environmentObject(LoginViewModel())
    }
}

extension SignUpView{

    
    private var navTitle: some View{
        Text("Create an account")
            .font(.urbMedium(size: 20))
            .padding(.bottom, 10)
    }
    private var step1: some View{
        VStack(alignment: .leading, spacing: 20) {
            Text("Step 1. Registration")
                .font(.urbMedium(size: 16))
            inputSectionStep1
            Divider().padding(.vertical, 20)
            socialButtonView
            Spacer()
        }
        .background(Color.bgWhite)
    }
    
    private var step2: some View{
        VStack(alignment: .leading, spacing: 20) {
            Text("Step 2. Add photo and name")
            avatarView
            inputSectionStep2
            Spacer()
        }
        .font(.urbMedium(size: 16))
        .background(Color.bgWhite)
    }
    
    private var successView: some View{
        ZStack {
            Color.accentBlue.ignoresSafeArea()
            VStack(spacing: 15) {
                Image("check")
                    .resizable()
                    .frame(width: 180, height: 180)
                    .aspectRatio(contentMode: .fill)
                Text("Registration Successfully Completed!!")
                    .font(.urbMedium(size: 20))
                    .foregroundColor(.bgWhite)
            }
        }
    }
    
    //MARK: - View Components
    
    
    private var avatarView: some View{
        ZStack{
            Color.lightGrey
            if let image = loginVM.imageData?.image{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }else{
                    Image("avatarDefault")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: 130, height: 130)
        .clipShape(Circle())
        .overlay(alignment: .bottomTrailing){
            ZStack{
                Circle()
                    .fill(Color.accentBlue)
                    Image(systemName: "plus")
                    .font(.callout)
                    .foregroundColor(.bgWhite)
            }
            .frame(width: 25, height: 25)
            .padding(8)
        }
        .hCenter()
        .onTapGesture {
            showImagePicker.toggle()
        }
    }
    
    private var inputSectionStep2: some View{
        VStack(alignment: .leading, spacing: 20) {
            TextFieldViewComponent(text: $loginVM.userFirstName, promt: "First name", font: .urbMedium(size: 16), height: 55)
            TextFieldViewComponent(text: $loginVM.userName, promt: "User name", font: .urbMedium(size: 16), height: 55)
            Text("Step 3. Add bio")
                .padding(.top, 20)
            TextFieldViewComponent(text: $loginVM.userBio, promt: "Tell about yourself", font: .urbMedium(size: 16), height: 55)
        }
        .padding(.top, 20)
    }
    
    private var inputSectionStep1: some View{
        VStack(alignment: .leading, spacing: 20) {
            TextFieldViewComponent(text: $loginVM.email, promt: "Email Address", font: .urbMedium(size: 16), height: 55)
            TextFieldViewComponent(text: $loginVM.pass, promt: "Password", font: .urbMedium(size: 16), height: 55, isSecureTF: true)
            TextFieldViewComponent(text: $loginVM.repeatPass, promt: "Repeat Password", font: .urbMedium(size: 16), height: 55, isSecureTF: true)
        }
    }
    private var socialButtonView: some View{
        VStack(alignment: .leading, spacing: 20) {
            SocialButton(isGoogleBtn: true, action: {})
            SocialButton(isGoogleBtn: false, action: {})
        }
    }
    private var bottomButtons: some View{
        
        var isStep1: Bool {
            currentStep == .step1
        }
        return  VStack(alignment: .leading, spacing: 20) {
            if loginVM.showLoader{
                ProgressLoader()
                    .frame(height: 50)
                    .hCenter()
            }else{
                CustomButtomView(title: isStep1 ? "Next" : "Create account", isDisabled: !loginVM.isValidSingUp(currentStep)) {
                    if currentStep == .step1{
                        loginVM.createAccount {
                            currentStep = .step2
                        }
                    }else{
                        loginVM.persistUserInfoToStorage()
                    }
                }
                .animation(nil, value: UUID().uuidString)
            }
            Button {
                withAnimation(.easeInOut(duration: 0.3)){
                    showLoginView.toggle()
                }
            } label: {
                Text("Already have an account?")
                    .foregroundColor(.accentBlue)
            }
            .font(.urbMedium(size: 16))
            .hCenter()
            .opacity(isStep1 ? 1 : 0)
            .disabled(!isStep1)
            .animation(nil, value: UUID().uuidString)
        }
        .padding(.bottom, 10)
    }
}



enum Step{
    case step1, step2, successfull
}
