//
//  Color+Extensions.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 11.09.2023.
//

import SwiftUI

protocol ColorThemeSettings {
    var accent: Color { get }
    var background: Color { get }
    var green: Color { get }
    var red: Color { get }
    var secondaryText: Color { get }
}

extension Color {
    static let theme: ColorThemeSettings = ColorTheme()
}

struct ColorTheme: ColorThemeSettings {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}
