//
//  Dim.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI

struct Dim: View {
    var body: some View {
        AppColor.black.color.opacity(0.5)
            .ignoresSafeArea()
    }
}

extension View {
    func dim(visible: Bool) -> some View {
        ZStack {
            self
            
            if visible {
                Dim()
            }
        }
    }
}
