//
//  MainView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 25.06.2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject private var userVM = UserManagerViewModel()
    @State private var selectionTab: Tab = .Chats
    init(){
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        VStack(spacing: 0){
            TabView(selection: $selectionTab) {
                NavigationView {
                    VStack(spacing: 0){
                        ContactsView()
                        tabBarView
                    }
                }
                .tag(Tab.Contacts)
                
                NavigationView {
                    VStack(spacing: 0) {
                        MainMessagesView()
                            .environmentObject(loginVM)
                            .environmentObject(userVM)
                        tabBarView
                    }
                }
                .tag(Tab.Chats)
                
                NavigationView {
                    VStack(spacing: 0) {
                        SettingsView()
                        tabBarView
                    }
                }
                .tag(Tab.Settings)
            }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LoginViewModel())
    }
}



enum Tab: String, CaseIterable {
    case Contacts = "Contacts"
    case Chats = "Chats"
    case Settings = "Settings"
}


extension MainView{
    
    private var tabBarView: some View{
        HStack(spacing: 0){
            Spacer()
            tabItem(Tab.Contacts)
            Spacer()
            tabItem(Tab.Chats)
            Spacer()
            tabItem(Tab.Settings)
            Spacer()
        }
        .padding(.top, 10)
        //.padding(.bottom, 3)
        .background(Color.white)
        .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: -2)
    }
    
    private func tabItem(_ tab: Tab) -> some View{
        VStack(spacing: 8){
            CustomIconView(imageName: tab.rawValue, width: 25, height: 25, color: tab == selectionTab ? .accentBlue : .gray, opacity: 1)
            Text(tab.rawValue)
                .font(.urbMedium(size: 16))
                .foregroundColor(tab == selectionTab ? .accentBlue : .gray)
        }
        .onTapGesture {
            withAnimation {
                selectionTab = tab
            }
        }
    }
}
