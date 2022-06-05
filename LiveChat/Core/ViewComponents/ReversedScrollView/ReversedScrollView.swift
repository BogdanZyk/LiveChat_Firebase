//
//  ReversedScrollView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 05.06.2022.
//

import SwiftUI

struct ReversedScrollView<Content: View>: View {
    var content: Content
    init(@ViewBuilder builder: () -> Content){
        self.content = builder()
    }
    var body: some View {
        GeometryReader{ proxy in
            ScrollView(.vertical, showsIndicators: true) {
                VStack{
                    Spacer()
                    content
                }
                .frame(minWidth: nil, minHeight: proxy.size.height)
            }
        }
    }
}

struct ReversedScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ReversedScrollView {
            ForEach(0..<5) { item in
                Text("\(item)")
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(6)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
