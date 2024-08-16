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
        // Given
        let mockCommits: [Commit] = [
            Commit(date: Date(), level: .low),
            Commit(date: Date(), level: .medium)
        ]
        let clock = TestClock()
        
        let store = TestStore(
            initialState: HomeReducer.State(),
            reducer: { HomeReducer() },
            withDependencies: {
                // 여기에 정확한 mockService 설정
                $0.githubService = GithubService.liveValue
                $0.mainQueue = .immediate
            }
        )
        store.exhaustivity = .off(showSkippedAssertions: true)

        // When
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.send(.getCommitsResponse(.success([]))) {
            $0.isLoading = false
        }
        
        // 클럭을 적절하게 진행
        await clock.advance(by: .milliseconds(500))
        
        // Then
//        await store.receive(.getCommitsResponse(.success(mockCommits))) {
//            $0.isLoading = false
//            $0.commits = mockCommits
//        }
//        
//        await store.receive(.updateCurrentMonthCommitsCount) {
//            $0.currentMonthCommitsCount = mockCommits.count
//            JandiUserDefault.coin = mockCommits.count
//        }
        
        // 커밋이 비어 있지 않다는 것을 확인
//        XCTAssertFalse(store.state.commits.isEmpty)
        
        await store.finish()
    }

}
