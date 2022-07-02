//
//  UserAvatarViewComponent.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI

struct UserAvatarViewComponent: View {
    let pathImage: String?
    var size: CGSize = .init(width: 37, height: 37)
    var body: some View {
        Group{
            if let image = pathImage, let imageUrl = URL(string: image){
                ImageView(imageUrl: imageUrl)
            }else{
                ZStack{
                    Color.appGrey
                    Image("avatarDefault")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .clipShape(Circle())
    }
}

struct UserAvatarViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatarViewComponent(pathImage: nil)
    }
}
