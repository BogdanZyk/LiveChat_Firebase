//
//  Helpers.swift
//  LiveChat
//
//  Created by Богдан Зыков on 04.06.2022.
//

import Foundation

final class Helpers{
    
    
    static func handleError(_ error: Error?, title: String, errorMessage: inout String, showAlert: inout Bool){
        if let error = error {
            errorMessage = "\(title) \(error.localizedDescription)"
            showAlert = true
        }
    }
}
