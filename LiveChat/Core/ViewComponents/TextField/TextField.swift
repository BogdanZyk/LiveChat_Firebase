//
//  TextField.swift
//  LiveChat
//
//  Created by Богдан Зыков on 25.06.2022.
//

import SwiftUI

struct TextFieldViewComponent: View {
    @Binding var text: String
    var promt: String = "Text here"
    var font: Font = .urbRegular(size: 16)
    var height: CGFloat = 60
    var cornerRadius: CGFloat = 20
    var body: some View {
        
        TextField(text: $text) {
            Text(promt)
        }
        .padding(.horizontal, 20)
        .frame(height: height)
        .hLeading()
        .background(Color.lightGreyNeutral, in: RoundedRectangle(cornerRadius: cornerRadius))
        .font(font)
    }
}

struct TextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            TextFieldViewComponent(text: .constant("21341"))
        }
    }
}
