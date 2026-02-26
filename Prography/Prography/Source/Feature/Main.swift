//
//  Main.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import ComposableArchitecture

@Reducer
struct MainFeature {
    @ObservableState
    struct State: Equatable {
        var selectedTab = Tab.schedule
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tabSelected(Tab)
    }
    
    enum Tab {
        case schedule
        case attendance
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
            }
        }
    }
}
