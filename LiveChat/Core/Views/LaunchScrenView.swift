//
//  LaunchScrenView.swift
//  LiveChat
//
//  Created by Богдан Зыков on 25.06.2022.
//

import SwiftUI

struct LaunchScrenView: View {
    @Binding var isActive: Bool
    var body: some View {
        ZStack{
            Color.bgWhite.ignoresSafeArea()
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 200)
                .offset(y: -5)
        }
        .onAppear{
            withAnimation(.easeInOut(duration: 0.3).delay(1)) {
                isActive = true
            }
        }
    }
}

struct LaunchScrenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScrenView(isActive: .constant(true))
    }
}
