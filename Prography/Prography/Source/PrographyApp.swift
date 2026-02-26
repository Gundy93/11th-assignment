//
//  PrographyApp.swift
//  Prography
//
//  Created by Jun Young Lee on 2/23/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct PrographyApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(initialState: RootFeature.State()) {
                    RootFeature()
                }
            )
        }
    }
}
