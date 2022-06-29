//
//  MainOnbordingView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 28.06.2022.
//

import SwiftUI

struct MainOnbordingView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @State var isFirstOpenApp: Bool = true
    @State private var showLoginView: Bool = true
    var body: some View {
        ZStack{
            if showLoginView{
                LoginView(showLoginView: $showLoginView)
                    .transition(.move(edge: .leading))
            }else {
                SignUpView(showLoginView: $showLoginView)
                    .transition(.move(edge: .leading))
            }
        }
        .environmentObject(loginVM)
        .alert("", isPresented: $loginVM.showAlert) {
            Button("OK", role: .cancel, action: {})
        } message: {
            Text(loginVM.errorMessage)
        }
        .fullScreenCover(isPresented: $isFirstOpenApp) {
            OnboardView(showLoginView: $showLoginView)
        }
    }
}

struct OnbordingView2_Previews: PreviewProvider {
    static var previews: some View {
        MainOnbordingView()
            .environmentObject(LoginViewModel())
    }
}




