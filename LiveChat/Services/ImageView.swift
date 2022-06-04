//
//  ImageView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    let imageUrl: String?
    var body: some View {
        Group{
            if let image = imageUrl, let imageUrl = URL(string: image){
                WebImage(url: imageUrl)
                    .resizable()
                    .placeholder{
                        Color.secondary.opacity(0.3)
                    }
            }else{
                Color.secondary.opacity(0.3)
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageUrl: "")
    }
}
