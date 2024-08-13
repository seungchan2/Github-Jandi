//
//  Publisher+Extension.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import Combine
import Foundation

extension Publisher {
    public func awaitOutput() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = self.sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .finished:
                    break
                }
                cancellable?.cancel()
            }, receiveValue: { value in
                continuation.resume(returning: value)
                cancellable?.cancel()
            })
        }
    }
}
