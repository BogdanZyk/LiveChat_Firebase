//
//  CustomIconsView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 25.06.2022.
//

import SwiftUI

struct CustomIconView: View {
    var imageName: String
    var width: CGFloat = 40
    var height: CGFloat = 40
    var color: Color = .accentBlue
    var opacity: Double = 0.7
    var body: some View {
        Image(imageName)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
            .foregroundColor(color.opacity(opacity))
    }
}
