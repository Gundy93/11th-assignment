//
//  Main.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI
import ComposableArchitecture

enum Tab: CaseIterable {
    case schedule
    case attendance
}

@Reducer
struct MainFeature {
    @ObservableState
    struct State: Equatable {
        let user: User
        var selectedTab = Tab.schedule
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tabSelected(Tab)
        case scanQRCodeButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .tabSelected(let tab):
                state.selectedTab = tab
                return .none
                
            case .scanQRCodeButtonTapped:
                return .none
            }
        }
    }
}

struct MainView: View {
    @Bindable var store: StoreOf<MainFeature>
    
    var body: some View {
        ZStack(alignment: .bottom) {
            tabView
            tabBar
        }
        .background(AppColor.white.color)
    }
    
    private var tabView: some View {
        ZStack {
            schedule
                .opacity(store.selectedTab == .schedule ? 1 : 0)
            attendance
                .opacity(store.selectedTab == .attendance ? 1 : 0)
        }
        .padding(
            .bottom,
            52
        )
        .frame(maxHeight: .infinity)
    }
    
    private var schedule: some View {
        Text("schedule")
    }
    
    private var attendance: some View {
        Text("attendance")
    }
    
    private var tabBar: some View {
        ZStack(alignment: .top) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    tabItem(tab)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background {
                AppColor.white.color
                    .shadow(
                        color: AppColor.black.color.opacity(0.04),
                        radius: 2,
                        x: 0,
                        y: -2
                    )
            }
            .padding(
                .top,
                26
            )
            
            floatingButton
        }
    }
    
    private func tabItem(_ tab: Tab) -> some View {
        VStack(spacing: 4) {
            tabItemIcon(tab)
                .image(
                    size: 20,
                    appColor: tabItemIconColor(tab)
                )
            tabItemLabel(tab)
        }
        .frame(maxWidth: .infinity)
        .padding(
            .top,
            4
        )
        .onTapGesture {
            store.send(.tabSelected(tab))
        }
    }

    private func tabItemLabel(_ tab: Tab) -> some View {
        Text(Texts.tabItem(tab))
            .appFont(
                AppFont.p4Regular,
                appColor: tabItemIconColor(tab)
            )
            .minimumScaleFactor(0.5)
    }
    
    private var floatingButton: some View {
        Button {
            store.send(.scanQRCodeButtonTapped)
        } label: {
            Circle()
                .fill(AppColor.primary.color)
                .frame(
                    width: 52,
                    height: 52
                )
                .shadow(
                    color: AppColor.black.color.opacity(0.1),
                    radius: 2,
                    x: 0,
                    y: 0
                )
                .overlay {
                    AppIcon.qrCode.image(
                        size: 24,
                        appColor: .white
                    )
                }
        }
    }
}

// MARK: UI Properties
extension MainView {
    private func tabItemIcon(_ tab: Tab) -> AppIcon {
        switch tab {
        case .schedule:
                .schedule
        case .attendance:
                .attendance
        }
    }
    
    private func tabItemIconColor(_ tab: Tab) -> AppColor {
        tab == store.selectedTab ? .primary : .gray50
    }
}

// MARK: Types
extension MainView {
    enum Texts {
        static func tabItem(_ tab: Tab) -> String {
            switch tab {
            case .schedule:
                "세션 일정"
            case .attendance:
                "출결 현황"
            }
        }
    }
}

#if DEBUG
#Preview {
    MainView(
        store: Store(
            initialState: MainFeature.State()
        ) {
            MainFeature()
        }
    )
}
#endif
