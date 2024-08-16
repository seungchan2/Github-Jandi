//
//  GithubService.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import Combine
import Foundation

import Dependencies
import DependenciesMacros
import SwiftSoup

@DependencyClient
public struct GithubService {
    public var getCommits: (_ id: String, _ year: Int) -> AnyPublisher<[Commit], APIError> = { _, _ in
        Just([]).setFailureType(to: APIError.self).eraseToAnyPublisher()
    }
}

extension GithubService: DependencyKey {
    public static var liveValue: Self {
        let apiService = APIService()
        return Self(
            getCommits: { id, year in
                let request = GithubServiceEndpoints
                    .getCommits(id: id, year: year)
                    .createRequest()
                
                return apiService.request(request)
                    .compactMap { String(data: $0, encoding: .ascii) }
                    .compactMap { html in
                        do {
                            let document = try SwiftSoup.parse(html)
                            let contributions = try document.select("td.ContributionCalendar-day")
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            return contributions.compactMap { element -> Commit? in
                                do {
                                    let date = try element.attr("data-date")
                                    let levelString = try element.attr("data-level")
                                    guard let levelInt = Int(levelString),
                                          let level = Commit.Level(rawValue: levelInt),
                                          let dateObj = formatter.date(from: date) else {
                                        return nil
                                    }
                                    return Commit(date: dateObj, level: level)
                                } catch {
                                    return nil
                                }
                            }
                        } catch {
                            return nil
                        }
                    }
                    .mapError { _ in APIError.invalidURL }
                    .eraseToAnyPublisher()
            }
        )
    }
    
    public static let previewValue = Self(
        getCommits: { _, _ in
            Just([Commit(date: Date(), level: .low)])
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
    )
}

extension GithubService: TestDependencyKey {
    public static let testValue = Self()
}
