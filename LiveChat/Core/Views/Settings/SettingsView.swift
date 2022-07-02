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
    init(){
        UIScrollView.appearance().bounces = false
    }
    @State private var isOnDarkMode: Bool = false
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
            CustomIconView(imageName: "share", width: 25, height: 25, color: .white, opacity: 1)
        }
    }
    private var navigationEditProfileBtn: some View{
        Button {
            
        } label: {
            CustomIconView(imageName: "pen", width: 20, height: 20, color: .white, opacity: 1)
        }
    }
    
    private var bannerImage: some View{
        ImageView(contentMode: .fill, imageUrl: URL(string: "https://home-cooks.s3.eu-west-2.amazonaws.com/menuHeaderImage/a6ce380c-b8d2-487f-8f36-496195883613")!)
            .frame(height: 160)
    }
    private var userAvatarSection: some View{
            UserAvatarViewComponent(pathImage: "", size: .init(width: 150, height: 150))
            .overlay(Circle().stroke(Color.bgWhite, lineWidth: 8))
            .padding(.top, 80)
    }
    
    private var userInfo: some View{
        Group {
            Group{
                Text("Salvador Martinez")
                    .font(.urbRegular(size: 20))
                HStack {
                    Label {
                        Text("@martinslvdr")
                    } icon: {
                        Image("star")
                    }
                    Label {
                        Text("+15852095357")
                    } icon: {
                        Image("star")
                    }
                }
                .font(.urbRegular(size: 16))
            }
            .foregroundColor(.fontPrimary)
            Text("Hello! This is my work number, please text me from 11 p .m. to 6 p.m. I’m availliable during this time!")
                .multilineTextAlignment(.center)
                .font(.urbRegular(size: 15))
                .frame(width: 300)
        }
        .foregroundColor(.secondaryFontGrey)
    }
    
    private var themeToggleView: some View{
        Toggle(isOn: $loginVM.isDarkMode) {
            Label {
                Text("Dark Mode")
            } icon: {
                Image("sun")
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





