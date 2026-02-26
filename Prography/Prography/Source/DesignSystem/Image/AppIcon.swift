//
//  AppIcon.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI

enum AppIcon: String {
    case delete = "xmark.circle.fill"
    
    func image(
        size: CGFloat,
        appColor: AppColor
    ) -> some View {
        Image(systemName: rawValue)
            .resizable()
            .frame(
                width: size,
                height: size
            )
            .foregroundStyle(appColor.color)
    }
}
