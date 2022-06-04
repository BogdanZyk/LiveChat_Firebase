//
//  StartView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI

struct StartView: View {
    @StateObject private var loginVM = LoginViewModel()
    var body: some View {
        Group{
            if loginVM.isloggedUser{
                MainMessagesView()
            }else{
                LoginView()
                    
            }
        }
        .environmentObject(loginVM)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
