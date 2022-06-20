//
//  UserProfileView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 12.06.2022.
//

import SwiftUI

struct UserProfileView: View {
    
    let userId: String?
    @StateObject private var profileVM: UserProfileViewModel
    
    init(userId: String?){
        self.userId = userId
        self._profileVM = StateObject(wrappedValue: UserProfileViewModel(userId: userId))
    }
    
    var body: some View {
        VStack{
            UserAvatarViewComponent(pathImage: profileVM.profileUser?.profileImageUrl, size: .init(width: 50, height: 50))
            Text(profileVM.profileUser?.name ?? "")
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(userId: "Sux8PnvfWTSTf9dqyYZE0BbKnuW2")
    }
}
