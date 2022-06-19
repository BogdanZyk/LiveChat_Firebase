//
//  ImageView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    let imageUrl: URL
    var body: some View {
        WebImage(url: imageUrl)
            .resizable()
            .placeholder{
                Color.secondary.opacity(0.3)
            }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageUrl: URL(string: "")!)
    }
}


