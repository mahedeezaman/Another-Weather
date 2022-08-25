//
//  UIApplicationExtension.swift
//  Weather App
//
//  Created by Mahedee Zaman on 13/5/22.
//

import UIKit

extension UIApplication {
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
