//
//  Fonts.swift
//  LiveChat
//
//  Created by Богдан Зыков on 25.06.2022.
//



import SwiftUI
//
//let urbRegular = "Urbanist-Regular"
//
//let urbMedium = "Urbanist-Medium"

extension Font {
    static func urbRegular(size: Int) -> Font {
        Font.custom("Urbanist-Regular", size: CGFloat(size))
    }
    static func urbMedium(size: Int) -> Font {
        Font.custom("Urbanist-Medium", size: CGFloat(size))
    }

}
