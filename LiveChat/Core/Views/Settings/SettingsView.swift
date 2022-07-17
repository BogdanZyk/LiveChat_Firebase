//
//  SettingsView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 25.06.2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var userVM: UserManagerViewModel
    @EnvironmentObject var colorSchemeService: ColorSchemeService
    @State private var showEditProfileVIew: Bool = false
    var body: some View {
        VStack(spacing: 0){
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    bannerImage
                    VStack(alignment: .center, spacing: 10) {
                        userAvatarSection
                        userInfo
                        VStack(alignment: .leading, spacing: 20) {
                            themeToggleView
                            Divider()
                            ForEach(TextConstants.settingsRowContent, id: \.id) { setting in
                                buttonLabelRow(setting.image, title: setting.title, color: setting.color)
                            }
                            logOutButtonView
                        }
                        .hLeading()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onChange(of: colorSchemeService.isDarkMode, perform: { _ in
            colorSchemeService.saveColorScheme()
        })
        .fullScreenCover(isPresented: $showEditProfileVIew){
            ChangeProfileInfoView(userVM: userVM)
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                navigationShareBtn
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationEditProfileBtn
            }
        })
        .background(Color.bgWhite)
        .ignoresSafeArea(.all, edges: .top)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environmentObject(ColorSchemeService())
                .environmentObject(LoginViewModel())
                .environmentObject(UserManagerViewModel())
                .preferredColorScheme(.dark)
        }
    }
}


extension SettingsView{
    
    private var navigationShareBtn: some View{
        Button {
            
        } label: {
            CustomIconView(imageName: "share", width: 25, height: 25, color: .accentBlue, opacity: 1)
        }
    }
    private var navigationEditProfileBtn: some View{
        Button {
            showEditProfileVIew.toggle()
        } label: {
            CustomIconView(imageName: "pen", width: 20, height: 20, color: .accentBlue, opacity: 1)
        }
    }
    
    private var bannerImage: some View{
        ZStack{
            if let banner = userVM.currentUser?.userBannerUrl, let url = URL(string: banner){
                ImageView(contentMode: .fill, imageUrl: url)
            }
            LinearGradient(colors: [.black.opacity(0.5) , .clear], startPoint: .bottom, endPoint: .top)
        }
        .frame(height: 160)
    }
    private var userAvatarSection: some View{
            UserAvatarViewComponent(pathImage: userVM.currentUser?.profileImageUrl, size: .init(width: 150, height: 150))
            .overlay(Circle().stroke(Color.bgWhite, lineWidth: 8))
            .padding(.top, 80)
    }
    
    private var userInfo: some View{
        Group {
            Group{
                Text("\(userVM.currentUser?.firstName ?? "") \(userVM.currentUser?.lastName ?? "")")
                    .font(.urbRegular(size: 20))
                
                HStack {
                    if let userName = userVM.currentUser?.userName, !userName.isEmpty{
                        Label {
                            Text("@\(userName)")
                        } icon: {
                            Image("star")
                        }
                    }
                    if let phone = userVM.currentUser?.phone, !phone.isEmpty{
                        Label {
                            Text("+\(phone)")
                        } icon: {
                            Image("star")
                        }
                    }
                }
                .font(.urbRegular(size: 16))
            }
            .foregroundColor(.fontPrimary)
            if let bio = userVM.currentUser?.bio{
                Text(bio)
                    .multilineTextAlignment(.center)
                    .font(.urbRegular(size: 15))
                    .frame(width: 300)
            }
        }
        .foregroundColor(.secondaryFontGrey)
    }
    
    private var themeToggleView: some View{
        Toggle(isOn: $colorSchemeService.isDarkMode) {
            Label {
                Text("Dark Mode")
            } icon: {
                CustomIconView(imageName: "sun", width: 15, height: 15, color: .fontPrimary, opacity: 1)
            }
        }
        .tint(.accentBlue)
        .padding(.top, 20)
    }
    
    
    private func buttonLabelRow(_ imageName: String, title: String, color: Color) -> some View{
        VStack(spacing: 20) {
            HStack{
                Label {
                    Text(title)
                } icon: {
                    ZStack{
                        color
                        Image(imageName)
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            if imageName == "fold" || imageName == "global"{
                Divider()
            }
        }
        .font(.urbRegular(size: 18))
        .foregroundColor(.fontPrimary)
    }
    private var logOutButtonView: some View{
        Button {
            loginVM.signOut()
        } label: {
            VStack{
                Text("Log Out")
                    .font(.urbMedium(size: 18))
                    .foregroundColor(.destructivRed)
            }
            .hCenter()
            .frame(height: 50)
            .background(Color.lightGrey, in: RoundedRectangle(cornerRadius: 10))
        }
        .padding(.top, 10)
    }
}





