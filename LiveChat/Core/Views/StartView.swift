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
        .environmentObject(loginVM)
        .sheet(isPresented: $loginVM.showModalView) {
            Text("Modal")
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
