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
    var cornerRadius: CGFloat = 10
    var isSecureTF: Bool = false
    @State private var showPass: Bool = false
    var body: some View {
        HStack{
            dinamicTextFieldView(showPass)
            Spacer()
            if isSecureTF{
                eyeButton
            }
        }
        .foregroundColor(.fontPrimary)
        .padding(.horizontal, 20)
        .frame(height: height)
        .hLeading()
        .background(Color.lightGrey, in: RoundedRectangle(cornerRadius: cornerRadius))
        .font(font)
        .onAppear {
            showPass = isSecureTF
        }
    }
}

struct TextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            TextFieldViewComponent(text: .constant("21341"))
                .padding()
                .preferredColorScheme(.dark)
        }
    }
}

extension TextFieldViewComponent{
    
    private func dinamicTextFieldView(_ isSecure: Bool) -> some View{
        Group{
          if isSecure {
                SecureField(text: $text) {
                    Text(promt)
                }
            }else{
                TextField(text: $text) {
                    Text(promt)
                }
            }
        }
    }
    private var eyeButton: some View{
        Button {
            showPass.toggle()
        } label: {
            Image(systemName: showPass ? "eye.fill" : "eye.slash.fill")
                .font(.callout)
                .foregroundColor(.secondaryFontGrey)
        }
    }
}
