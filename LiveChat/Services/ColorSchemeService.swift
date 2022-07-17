//
//  DarkModeService.swift
//  LiveChat
//
//  Created by Богдан Зыков on 17.07.2022.
//

import SwiftUI
final class ColorSchemeService: ObservableObject{
    

    
    init(){
       setupColorScheme()
    }
    
    @Published var isDarkMode: Bool = false
    
    @AppStorage("savedDark") var savedDark: Bool = false
    
    public func setupColorScheme(){
        isDarkMode = savedDark 
    }
    
    public func saveColorScheme(){
       savedDark = isDarkMode
    }
}

