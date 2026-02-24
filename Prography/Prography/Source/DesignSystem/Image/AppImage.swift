//
//  AppImage.swift
//  Prography
//
//  Created by Jun Young Lee on 2/23/26.
//

import SwiftUI

enum AppImage: String {
    case logo = "logo"

    var image: Image {
        Image(rawValue)
            .resizable()
    }

    func coloredImage(
        appColor: AppColor
    )  -> some View {
        image
            .renderingMode(.template)
            .foregroundStyle(appColor.color)
    }
}
