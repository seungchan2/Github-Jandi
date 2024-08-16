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
public struct HomeFeature {
    @ObservableState
    public struct State: Equatable {
        var commits: [Commit] = []
        var isLoading: Bool = false
        var errorMessage: String?
        var currentMonthCommitsCount: Int = 0
    }
    
    public enum Action: Equatable {
        case onAppear
        case getCommitsResponse(Result<[Commit], APIError>)
        case updateCurrentMonthCommitsCount
    }
    
    @Dependency(\.githubService) var githubService

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return onAppear(&state)
            
        case let .getCommitsResponse(.success(commits)):
            return fetchCommitsSuccess(&state, commits: commits)
            
        case let .getCommitsResponse(.failure(error)):
            return fetchCommitsFailure(&state, error: error)
            
        case .updateCurrentMonthCommitsCount:
            return updateCurrentMonthCommitsCount(&state)
        }
    }
        
    private func onAppear(_ state: inout State) -> Effect<Action> {
        state.isLoading = true
        return .run { send in
            let years = [2021, 2022, 2023, 2024]
            var allCommits: [Commit] = []
            
            for year in years {
                do {
                    let commits = try await self.githubService.getCommits("seungchan2", year)
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
    
    private func fetchCommitsSuccess(_ state: inout State, commits: [Commit]) -> Effect<Action> {
        state.isLoading = false
        state.commits = commits
        return .send(.updateCurrentMonthCommitsCount)
    }
    
    private func fetchCommitsFailure(_ state: inout State, error: APIError) -> Effect<Action> {
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none
    }
    
    private func updateCurrentMonthCommitsCount(_ state: inout State) -> Effect<Action> {
        let nonNoneCommits = state.commits.filter { $0.level != .none }
        state.currentMonthCommitsCount = nonNoneCommits.count
        JandiUserDefault.coin = nonNoneCommits.count
        return .none
    }
}
