//
//  GithubService.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import Combine
import Foundation

import Dependencies
import SwiftSoup

public protocol GithubServiceType {
    func getCommits(id: String, year: Int) -> AnyPublisher<[Commit], APIError>
}

public final class GithubService: GithubServiceType {
    private var apiService: RequestType
    
    public init(apiService: RequestType) {
        self.apiService = apiService
    }
    
    public func getCommits(id: String, year: Int) -> AnyPublisher<[Commit], APIError> {
        let request = GithubServiceEndpoints
            .getCommits(id: id, year: year)
            .createRequest(
            )
        return self.apiService.request(request)
            .compactMap { String(data: $0, encoding: .ascii) }
            .compactMap(getCommits)
            .eraseToAnyPublisher()
    }
    
    private func getCommits(from html: String) -> [Commit]? {
        do {
            let document = try SwiftSoup.parse(html)
            let contributions = try document.select("td.ContributionCalendar-day")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let commits = contributions.compactMap { element -> Commit? in
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
            return commits
        } catch {
            return nil
        }
    }
}

extension GithubService: DependencyKey {
    public static var liveValue = GithubService(apiService: APIService())
}
