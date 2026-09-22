//
//  FailedAdRepository.swift
//  OsmosAdsDemo
//
//  Created by Bhushan Sangale on 22/09/26.
//

import Foundation

struct FailedAdRepository: AdRepository {

    let error: Error

    func fetchAds() async throws -> [Ad] {
        throw error
    }
}
