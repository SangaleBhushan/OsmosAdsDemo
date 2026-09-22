//
//  OsmosSDKService.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import Foundation
import osmos

protocol OsmosSDKServiceProtocol: Sendable {
    func fetchAds() async throws -> [Ad]
}

final class OsmosSDKService: OsmosSDKServiceProtocol {

    func fetchAds() async throws -> [Ad] {
        let osmosManager = try OSMOS.shared()

        guard let adFetcher = osmosManager.adFetcher() else {
            throw OsmosSDKError.adFetcherUnavailable
        }

        let response = await adFetcher.fetchDisplayAdsWithAu(
            cliUbid: "Any",
            pageType: "demo_page",
            productCount: 5,
            adUnits: ["banner_ads"],
            targetingParams: nil,
            onError: { error in
                AppLogger.error("OSMOS ad fetch failed: \(error)")
            }
        )

        guard let response else {
            throw OsmosSDKError.emptyResponse
        }

        do {
            let ads = try OsmosAdMapper.map(response)
            AppLogger.info("OSMOS ads loaded: \(ads.count)")
            return ads
        } catch {
            AppLogger.error("OSMOS response mapping failed: \(error.localizedDescription)")
            throw error
        }
    }
}
