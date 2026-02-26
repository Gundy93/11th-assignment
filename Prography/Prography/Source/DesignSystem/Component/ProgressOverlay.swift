//
//  ProgressIndicator.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI

struct ProgressOverlay: View {
    @State private var rotation = Double.zero

    var body: some View {
        ZStack {
            AppColor.white.color.opacity(0.5)
            progressRing
        }
        .ignoresSafeArea()
    }
    
    private var progressRing: some View {
        Circle()
            .trim(
                from: 0.2,
                to: 1
            )
            .stroke(
                AppColor.primary20.color,
                style: StrokeStyle(
                    lineWidth: 6,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
            .frame(
                width: 45,
                height: 45
            )
    }
}

extension View {
    func progressOverlay(visible: Bool) -> some View {
        ZStack {
            self
            
            if visible {
                ProgressOverlay()
            }
        }
    }
}
