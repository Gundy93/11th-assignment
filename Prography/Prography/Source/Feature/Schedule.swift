//
//  Schedule.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ScheduleFeature {
    @ObservableState
    struct State: Equatable {
        var sessions = [PrographySession]()
        var selectedSession: PrographySession?
        var isLoading = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case viewTaskCalled
        case sessionsFetched([PrographySession])
        case startLoading
        case endLoading
        case sessionTapped(PrographySession)
    }
    
    @Dependency(\.sessionService) var sessionService
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .viewTaskCalled:
                return .run { send in
                    await send(.startLoading)
                    
                    let result = try await sessionService.fetchSessions()
                    
                    switch result {
                    case .success(let sessions):
                        await send(.sessionsFetched(sessions))
                    case .failure(let error):
                        throw error
                    }
                    
                    await send(.endLoading)
                } catch: { error, send in
                    #if DEBUG
                    print(error)
                    #endif
                    
                    await send(.endLoading)
                }
                
            case .sessionsFetched(let sessions):
                state.sessions = sessions.sorted {
                    $0.date < $1.date
                }
                state.selectedSession = state.sessions.first {
                    .now < $0.date
                }
                return .none
                
            case .startLoading:
                state.isLoading = true
                return .none

            case .endLoading:
                state.isLoading = false
                return .none
                
            case .sessionTapped(let session):
                state.selectedSession = session
                return .none
            }
        }
    }
}
