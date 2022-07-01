//
//  UserProfileView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 12.06.2022.
//

import SwiftUI

struct UserProfileView: View {
    
    var user: User?
    
    var body: some View {
        VStack{
            UserAvatarViewComponent(pathImage: user?.profileImageUrl, size: .init(width: 50, height: 50))
            Text(user?.firstName ?? "")
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
