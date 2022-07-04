//
//  ProgressLoader.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.07.2022.
//

import SwiftUI

struct ProgressLoader: View {
    var color: Color = .accentColor
    var scaleEffect: CGFloat = 1.7
    var body: some View {
        ProgressView()
            .scaleEffect(scaleEffect, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: color.opacity(0.8)))
    }
}

struct ProgressLoader_Previews: PreviewProvider {
    static var previews: some View {
        ProgressLoader()
    }
}
