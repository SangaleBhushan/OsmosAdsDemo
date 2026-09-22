//
//  OsmosAdRepository.swift
//  OsmosAdsDemo
//
//  Created by Bhushan Sangale on 21/09/26.
//

import Foundation

final class OsmosAdRepository: AdRepository {

    private let sdkService: any OsmosSDKServiceProtocol

    init(sdkService: any OsmosSDKServiceProtocol) {
        self.sdkService = sdkService
    }

    func fetchAds() async throws -> [Ad] {
        try await sdkService.fetchAds()
    }
}
