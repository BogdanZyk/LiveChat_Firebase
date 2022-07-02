//
//  StartView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI

struct StartView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var loginVM = LoginViewModel()
    @State private var isActive: Bool = false
    var body: some View {
        Group{
            if isActive{
                if loginVM.isloggedUser{
                    MainView()
                }else{
                    MainOnbordingView()
                }
            }else{
                LaunchScrenView(isActive: $isActive)
            }
        }
        .preferredColorScheme(loginVM.isDarkMode ? .dark : .light)
        .environmentObject(loginVM)
        .sheet(isPresented: $loginVM.showModalView) {
            Text("Modal")
        }
        .onAppear {
            loginVM.isDarkMode = colorScheme == .dark
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
