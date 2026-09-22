//
//  MockAdRepository.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import Foundation

struct MockAdRepository: AdRepository {

    private let result: MockRepositoryResult

    init(result: MockRepositoryResult = .success([])) {
        self.result = result
    }

    func fetchAds() async throws -> [Ad] {
        try await Task.sleep(nanoseconds: 200_000_000)

        switch result {
        case .success(let ads):
            return ads
        case .failure(let message):
            throw MockRepositoryError(message: message)
        }
    }
}

enum MockRepositoryResult: Sendable {
    case success([Ad])
    case failure(String)
}

struct MockRepositoryError: LocalizedError, Sendable {

    let message: String

    var errorDescription: String? {
        message
    }
}
