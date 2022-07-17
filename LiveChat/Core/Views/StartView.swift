//
//  StartView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI

struct StartView: View {
    @StateObject private var loginVM = LoginViewModel()
    @State private var isActive: Bool = false
    @StateObject private var colorSchemeService = ColorSchemeService()
    var body: some View {
        Group{
            if isActive{
                if loginVM.isloggedUser{
                    MainView()
                        .environmentObject(colorSchemeService)
                }else{
                    MainOnbordingView()
                }
            }else{
                LaunchScrenView(isActive: $isActive)
            }
        }
        .preferredColorScheme(colorSchemeService.isDarkMode ? .dark : .light)
        .environmentObject(loginVM)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
