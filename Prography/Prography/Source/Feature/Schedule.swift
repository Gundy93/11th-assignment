//
//  Schedule.swift
//  Prography
//
//  Created by Jun Young Lee on 2/26/26.
//

import SwiftUI
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

struct ScheduleView: View {
    @Bindable var store: StoreOf<ScheduleFeature>
    
    @State private var informationFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd EE HH:mm"
        
        return formatter
    }()
    
    @State private var sessionsFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd EE"
        
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            informationSection
            sessionsSection
        }
        .background(safeAreaGradient)
        .task {
            store.send(.viewTaskCalled)
        }
        .progressOverlay(visible: store.isLoading)
    }
    
    private var informationSection: some View {
        VStack(
            alignment: .leading,
            spacing: 20
        ) {
            sectionHeader(Texts.informationHeader)
            informationContent
        }
        .padding(20)
        .background(sessionInformationGradient)
    }
    
    private func sectionHeader(_ text: String) -> some View {
        HStack {
            Text(text)
                .appFont(
                    .p2SemiBold,
                    appColor: .black
                )
            Spacer()
        }
    }
    
    private var informationContent: some View {
        VStack(spacing: 20) {
            date
            title
            location
        }
        .padding(
            .vertical,
            20
        )
        .frame(maxWidth: .infinity)
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(informationContentGradient)
        }
        .padding(
            .bottom,
            20
        )
    }
    
    private var date: some View {
        let isFetched = store.selectedSession != nil
        
        return Text(isFetched ? informationFormatter.string(from: store.selectedSession?.date ?? .now) : " ")
            .appFont(
                .p2SemiBold,
                appColor: .gray70
            )
    }
    
    private var title: some View {
        Text(store.selectedSession?.title ?? " ")
            .multilineTextAlignment(.center)
            .appFont(
                .h1Bold,
                appColor: .black
            )
        
    }
    
    private var location: some View {
        Text(store.selectedSession?.location ?? " ")
            .appFont(
                .p1SemiBold,
                appColor: .gray70
            )
    }
    
    private var sessionsSection: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            sectionHeader(Texts.sessionsHeader)
                .padding(
                    EdgeInsets(
                        top: 20,
                        leading: 20,
                        bottom: 12,
                        trailing: 20
                    )
                )
            sessions
            Spacer()
        }
        .background(AppColor.gray10.color)
    }
    
    private var sessions: some View {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 16){
                        ForEach(store.sessions, id: \.id) { session in
                            Button {
                                store.send(.sessionTapped(session))
                            } label: {
                                sessionCell(session)
                            }
                        }
                    }
                    .padding(
                        EdgeInsets(
                            top: 8,
                            leading: 20,
                            bottom: 20,
                            trailing: 20
                        )
                    )
                }
                .onChange(of: store.sessions) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        scrollProxy.scrollTo(
                            store.selectedSession?.id,
                            anchor: .top
                        )
                    }
                }
            }
       
    }
    
    private func sessionCell(_ session: PrographySession) -> some View {
        VStack(
            alignment: .leading,
            spacing: 4
        ) {
            Text(session.title)
                .appFont(
                    .h2Bold,
                    appColor: .black
                )
            HStack(spacing: 0) {
                Text(sessionsFormatter.string(from: session.date))
                    .appFont(
                        .p2Regular,
                        appColor: .gray80
                    )
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(sesionCellBackground(session))
        .overlay(sesionCellBorder(session))
        .id(session.id)
    }
    
    private func sesionCellBackground(_ session: PrographySession) -> some View {
        let isSelected = store.selectedSession == session
        
        return RoundedRectangle(cornerRadius: 12)
            .fill(isSelected ? AppColor.primary20.color : AppColor.white.color)
            .shadow(
                color: AppColor.black.color.opacity(0.25),
                radius: 2,
                x: 0,
                y: 0
            )
    }
    
    private func sesionCellBorder(_ session: PrographySession) -> some View {
        let isSelected = store.selectedSession == session
        
        return RoundedRectangle(cornerRadius: 12)
            .strokeBorder(
                isSelected ? AppColor.primary.color : .clear,
                lineWidth: 1
            )
    }
}

// MARK: UI Properties
extension ScheduleView {
    private var safeAreaGradient: LinearGradient {
        LinearGradient(
            colors: [
                AppColor.primary20.color,
                AppColor.primary20.color,
                AppColor.white.color,
                AppColor.gray10.color,
                AppColor.gray10.color
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var sessionInformationGradient: LinearGradient {
        LinearGradient(
            colors: [
                AppColor.primary20.color,
                AppColor.white.color
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var informationContentGradient: LinearGradient {
        LinearGradient(
            colors: [
                AppColor.primary40.color,
                AppColor.primary20.color
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: Types
extension ScheduleView {
    enum Texts {
        static let informationHeader = "세션 정보"
        static let sessionsHeader = "세션 일정"
    }
}

#if DEBUG
#Preview {
    ScheduleView(
        store: Store(
            initialState: ScheduleFeature.State()
        ) {
            ScheduleFeature()
        }
    )
}
#endif
