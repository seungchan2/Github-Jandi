//
//  Jandi_PlantTests.swift
//  Jandi-PlantTests
//
//  Created by MEGA_Mac on 8/2/24.
//

import Combine
import XCTest

import Core
import Dependencies
import JandiNetwork

import ComposableArchitecture

final class HomeReducerTests: XCTestCase {
    
    func test_onAppear_fetchCommitsSuccess() async throws {
//        // Given
//        let mockCommits: [Commit] = [
//            Commit(date: Date(), level: .low),
//            Commit(date: Date(), level: .medium)
//        ]
//        
//        var githubServiceMock = GithubServiceMock(apiService: APIService())
//        githubServiceMock.mockCommits = mockCommits
//        
//        
//        let store = TestStore(
//            initialState: HomeReducer.State(),
//            reducer: { HomeReducer() },
//            withDependencies: {
//                $0.githubService = mockService
//            }
//        )
//        
//        store.dependencies.githubService = mockService
//        
//        // When
//        await store.send(.onAppear) {
//            $0.isLoading = true
//        }
//        
//        // Then
//        await store.receive(.getCommitsResponse(.success(mockCommits))) {
//            $0.isLoading = false
//            $0.commits = mockCommits
//        }
//        
//        await store.receive(.updateCurrentMonthCommitsCount) {
//            $0.currentMonthCommitsCount = mockCommits.count
//            JandiUserDefault.coin = mockCommits.count
//        }
    }
    
//    func test_onAppear_fetchCommitsFailure() async throws {
//        // Given
//        let mockError = APIError.invalidURL
//        let githubServiceMock = GithubServiceMock(apiService: APIService())
//        githubServiceMock.mockError = mockError
//        
//        
//        let store = TestStore(
//            initialState: HomeReducer.State(),
//            reducer: { HomeReducer() },
//            withDependencies: {
//                $0.githubService = mockService
//            }
//        )
//        
//        // Inject mock service
//        store.dependencies.githubService = mockService
//        
//        // When
//        await store.send(.onAppear) {
//            $0.isLoading = true
//        }
//        
//        // Then
//        await store.receive(.getCommitsResponse(.failure(mockError))) {
//            $0.isLoading = false
//            $0.errorMessage = mockError.localizedDescription
//        }
//    }
    //    // Test failure when fetching commits
    //    func test_getCommitsResponse_failure() async throws {
    //        // Given
    //        let mockError = APIError.networkError
    //        let store = TestStore(
    //            initialState: HomeReducer.State(),
    //            reducer: HomeReducer()
    //        )
    //
    //        store.dependencies.githubService.getCommits = { _, _ in
    //            Effect(error: mockError)
    //        }
    //
    //        // When
    //        await store.send(.onAppear) {
    //            $0.isLoading = true
    //        }
    //
    //        // Then
    //        await store.receive(.getCommitsResponse(.failure(mockError))) {
    //            $0.isLoading = false
    //            $0.errorMessage = mockError.localizedDescription
    //        }
    //    }
    //
    //    // Test updateCurrentMonthCommitsCount action
    //    func test_updateCurrentMonthCommitsCount() async throws {
    //        // Given
    //        let commits: [Commit] = [
    //            Commit(date: Date(), level: .low),
    //            Commit(date: Date(), level: .none),
    //            Commit(date: Date(), level: .medium)
    //        ]
    //
    //        let store = TestStore(
    //            initialState: HomeReducer.State(commits: commits),
    //            reducer: HomeReducer()
    //        )
    //
    //        // When
    //        await store.send(.updateCurrentMonthCommitsCount) {
    //            $0.currentMonthCommitsCount = 2 // Only 2 commits with level != .none
    //            JandiUserDefault.coin = 2
    //        }
    //    }
}
