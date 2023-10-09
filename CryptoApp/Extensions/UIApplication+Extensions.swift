//
//  UIApplication+Extensions.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 09.10.2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
