//
//  AppFont.swift
//  Prography
//
//  Created by Jun Young Lee on 2/23/26.
//

import SwiftUI

enum AppFont {
    case h1Bold
    case h1SemiBold
    case h2Bold
    case h2Regular
    case h2SemiBold
    case p1Bold
    case p1Regular
    case p1SemiBold
    case p2Bold
    case p2Regular
    case p2SemiBold
    case p3Bold
    case p3Regular
    case p3SemiBold
    case p4Regular
    case p4SemiBold
    case custom(
        FontFamily,
        size: CGFloat,
        Typography,
        lineSpacing: CGFloat
    )

    private var fontFamily: FontFamily {
        switch self {
        case .h1Bold, .h2Bold, .p1Bold, .p2Bold, .p3Bold:
                .bold
        case .h1SemiBold, .h2SemiBold, .p1SemiBold, .p2SemiBold, .p3SemiBold, .p4SemiBold:
                .semiBold
        case .h2Regular, .p1Regular, .p2Regular, .p3Regular, .p4Regular:
                .regular
        case .custom(let family, _, _, _):
            family
        }
    }

    private var size: CGFloat {
        switch self {
        case .h1Bold, .h1SemiBold:
            24
        case .h2Bold, .h2Regular, .h2SemiBold:
            20
        case .p1Bold, .p1Regular, .p1SemiBold:
            18
        case .p2Bold, .p2Regular, .p2SemiBold:
            16
        case .p3Bold, .p3Regular, .p3SemiBold:
            14
        case .p4Regular, .p4SemiBold:
            13
        case .custom(_, let size, _, _):
            size
        }
    }

    private var typography: Typography {
        switch self {
        case .custom(_, _, let typography, _):
            typography
        default:
                .pretendard
        }
    }

    private var fileName: String {
        "\(typography.fileNamePrefix)-\(fontFamily.fileNameSuffix)"
    }

    fileprivate var font: Font {
        .custom(
            fileName,
            fixedSize: size
        )
    }
    
    private var uiFont: UIFont {
        return .init(
            name: fileName,
            size: size
        ) ?? .systemFont(ofSize: size)
    }

    fileprivate var lineSpacing: CGFloat {
        switch self {
        case .h1Bold, .h1SemiBold, .p3Bold, .p3Regular, .p3SemiBold, .p4Regular, .p4SemiBold:
            uiFont.pointSize * 0.4 / 2
        case .h2Bold, .h2Regular, .h2SemiBold, .p1Bold, .p1Regular, .p1SemiBold, .p2Bold, .p2Regular, .p2SemiBold:
            uiFont.pointSize * 0.5 / 2
        case .custom(_, _, _, let lineSpacing):
            lineSpacing
        }
    }
}

extension AppFont {
    enum Typography: String {
        case pretendard = "Pretendard"

        fileprivate var fileNamePrefix: String {
            rawValue
        }
    }

    enum FontFamily {
        case bold
        case regular
        case semiBold

        fileprivate var fileNameSuffix: String {
            switch self {
            case .bold:
                "Bold"
            case .regular:
                "Regular"
            case .semiBold:
                "SemiBold"
            }
        }
    }
}

extension View {
    func appfont(
        _ appFont: AppFont,
        appColor: AppColor
    ) -> some View {
        self
            .font(appFont.font)
            .foregroundStyle(appColor.color)
            .padding(.vertical, appFont.lineSpacing / 2)
            .lineSpacing(appFont.lineSpacing)
    }

    func appfont(
        _ appFont: AppFont,
        color: Color
    ) -> some View {
        self
            .font(appFont.font)
            .foregroundStyle(color)
            .padding(.vertical, appFont.lineSpacing / 2)
            .lineSpacing(appFont.lineSpacing)
    }
}
