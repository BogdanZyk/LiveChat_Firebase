//
//  ImageView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    var contentMode: ContentMode = .fill
    let imageUrl: URL
    var body: some View {
        WebImage(url: imageUrl)
            .placeholder{
                Color.gray
            }
            .centerCropped()
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageUrl: URL(string: "")!)
    }
}


