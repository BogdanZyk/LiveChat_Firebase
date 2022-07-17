//
//  MainView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 25.06.2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var colorSchemeService: ColorSchemeService
    @StateObject private var userVM = UserManagerViewModel()
    @StateObject private var contactVM = ContactsViewModel()
    @State private var selectionTab: Tab = .Chats
    init(){
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        VStack(spacing: 0){
            TabView(selection: $selectionTab) {
                NavigationView {
                    ContactsView()
                        .environmentObject(contactVM)
                        .safeAreaInset(edge: .bottom){
                            tabBarView
                        }
                }
                .tag(Tab.Contacts)
                
                NavigationView {
                    MainMessagesView()
                        .environmentObject(contactVM)
                        .environmentObject(userVM)
                        .safeAreaInset(edge: .bottom){
                            tabBarView
                        }
                    
                }
                .tag(Tab.Chats)
                
                NavigationView {
                    SettingsView()
                        .environmentObject(colorSchemeService)
                        .environmentObject(loginVM)
                        .environmentObject(userVM)
                        .safeAreaInset(edge: .bottom){
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
            .preferredColorScheme(.dark)
    }
}



enum Tab: String, CaseIterable {
    case Contacts = "Contacts"
    case Chats = "Chats"
    case Settings = "Settings"
}


extension MainView{
    
    private var tabBarView: some View{
        VStack(spacing: 0) {
            Divider()
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
        }
        .background(Color.bgWhite)
    }
    
    private func tabItem(_ tab: Tab) -> some View{
        VStack(spacing: 6){
   
            CustomIconView(imageName: tab.rawValue, width: 20, height: 20, color: tab == selectionTab ? .accentBlue : .gray, opacity: 1)
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
