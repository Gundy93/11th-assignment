//
//  AppColor.swift
//  Prography
//
//  Created by Jun Young Lee on 2/23/26.
//

import SwiftUI

enum AppColor: String {
    // Primary
    case primary = "#FA2454"
    case primary20 = "#FFE5EC"
    case primary40 = "#FFB3C2"
    case primary60 = "#FF6F8E"
    case primary80 = "#D81E49"
    
    // Sub
    case navy = "#1B1F3B"
    case navy20 = "#D6D8E2"
    case navy40 = "#5B6178"
    case lavender = "#8E7CFF"
    case lavender20 = "#EAE7FF"
    case mint = "#2ED6A1"
    case mint20 = "#D9FBF0"

    // Neutral
    case white  = "#FFFFFF"
    case gray10 = "#F8F8FA"
    case gray20 = "#ECECF2"
    case gray30 = "#E0E1E8"
    case gray40 = "#C8CAD3"
    case gray50 = "#9DA0AB"
    case gray60 = "#6F7380"
    case gray70 = "#4A4D57"
    case gray80 = "#262830"
    case black  = "#000000"

    var color: Color {
        Color(hex: rawValue)
    }
}

fileprivate extension Color {
    init(hex: String) {
        var hexStr = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        if hexStr.hasPrefix("#") {
            hexStr.removeFirst()
        }

        var hexValue: UInt64 = 0
        Scanner(string: hexStr).scanHexInt64(&hexValue)

        let hasAlpha = (hexStr.count == 8)
        let divisor = Double(255)
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double

        if hasAlpha {
            red   = Double((hexValue & 0xFF000000) >> 24) / divisor
            green = Double((hexValue & 0x00FF0000) >> 16) / divisor
            blue  = Double((hexValue & 0x0000FF00) >> 8 ) / divisor
            alpha = Double( hexValue & 0x000000FF       ) / divisor
        } else {
            red   = Double((hexValue & 0xFF0000) >> 16) / divisor
            green = Double((hexValue & 0x00FF00) >> 8 ) / divisor
            blue  = Double( hexValue & 0x0000FF       ) / divisor
            alpha = 1.0
        }

        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
}
