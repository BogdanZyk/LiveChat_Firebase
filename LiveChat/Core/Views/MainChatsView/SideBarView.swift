//
//  SideBarView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI

struct SideBarView: View {
    //@EnvironmentObject var mainMessVM: MainMessagesViewModel
    @ObservedObject var loginVM: LoginViewModel
    @State private var showSignOutConfirm = false
    var body: some View {
        VStack {
            List{
                Text("avatar")
                Text("UserName")
                Button {
                    showSignOutConfirm.toggle()
                } label: {
                    Text("Sign out")
                }
            }
        }
        .confirmationDialog("What do you want to do?", isPresented: $showSignOutConfirm, titleVisibility: .visible) {
            Button("Sign out", role: .destructive) {
                loginVM.signOut()
            }
        }
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView(loginVM: LoginViewModel())
    }
}
