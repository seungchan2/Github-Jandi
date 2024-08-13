//
//  HomeReducer.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/5/24.
//

import Combine

import Core
import JandiNetwork

import ComposableArchitecture

@Reducer
struct HomeReducer {
    struct State: Equatable {
        var commits: [Commit] = []
        var isLoading: Bool = false
        var errorMessage: String?
        var currentMonthCommitsCount: Int = 0
    }
    
    enum Action: Equatable {
        case onAppear
        case getCommitsResponse(Result<[Commit], APIError>)
        case updateCurrentMonthCommitsCount
    }
    
    @Dependency(\.githubService) var githubService

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return handleOnAppear(&state)
            
        case let .getCommitsResponse(.success(commits)):
            return handleGetCommitsSuccess(&state, commits: commits)
            
        case let .getCommitsResponse(.failure(error)):
            return handleGetCommitsFailure(&state, error: error)
            
        case .updateCurrentMonthCommitsCount:
            return handleUpdateCurrentMonthCommitsCount(&state)
        }
    }
        
    private func handleOnAppear(_ state: inout State) -> Effect<Action> {
        state.isLoading = true
        return .run { send in
            let years = [2021, 2022, 2023, 2024]
            var allCommits: [Commit] = []
            
            for year in years {
                do {
                    let commits = try await self.githubService.getCommits(id: "seungchan2", year: year)
                        .mapError { $0 as Error }
                        .awaitOutput()
                    allCommits.append(contentsOf: commits)
                } catch {
                    await send(.getCommitsResponse(.failure(error as! APIError)))
                    return
                }
            }
            
            await send(.getCommitsResponse(.success(allCommits)))
        }
    }
    
    private func handleGetCommitsSuccess(_ state: inout State, commits: [Commit]) -> Effect<Action> {
        state.isLoading = false
        state.commits = commits
        return .send(.updateCurrentMonthCommitsCount)
    }
    
    private func handleGetCommitsFailure(_ state: inout State, error: APIError) -> Effect<Action> {
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none
    }
    
    private func handleUpdateCurrentMonthCommitsCount(_ state: inout State) -> Effect<Action> {
        let nonNoneCommits = state.commits.filter { $0.level != .none }
        state.currentMonthCommitsCount = nonNoneCommits.count
        JandiUserDefault.coin = nonNoneCommits.count
        return .none
    }
}
