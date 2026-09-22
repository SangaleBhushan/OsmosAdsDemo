//
//  AdsViewModel.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import Observation
import Foundation

@MainActor
@Observable
final class AdsViewModel {

    private let repository: any AdRepository
    private let eventTracker: any AdEventTrackerProtocol

    private(set) var ads: [Ad] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private(set) var impressionCount = 0
    private(set) var clickCount = 0

    private var trackedImpressions = Set<String>()

    init(repository: any AdRepository,eventTracker: any AdEventTrackerProtocol){
        self.repository = repository
        self.eventTracker = eventTracker
    }

    var loadedCount: Int {
        ads.count
    }

    // MARK: - Fetch Ads

    func loadAds() async {

        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            let fetchedAds = try await repository.fetchAds()

            guard !fetchedAds.isEmpty else {

                ads = []

                errorMessage = "No advertisement is currently available."

                AppLogger.error("Ad Failed - Empty response")

                return
            }

            ads = fetchedAds

            AppLogger.info("Ad Loaded - \(fetchedAds.count) ad(s)")

        } catch {

            errorMessage = error.localizedDescription
            AppLogger.error("Ad Failed - \(error.localizedDescription)")

        }
    }

    // MARK: - Impression

    func handleVisibility(for ad: Ad,isVisible: Bool){

        guard isVisible else {
            return
        }

        guard !trackedImpressions.contains(ad.id) else {
            return
        }

        // Mark immediately.
        // This prevents duplicate events caused
        // by multiple geometry updates.
        trackedImpressions.insert(ad.id)

        impressionCount += 1

        AppLogger.info("Impression Fired - position \(ad.position)")

        Task {
            await eventTracker.trackImpression(for: ad)
        }
    }

    // MARK: - Click

    func handleClick(for ad: Ad) {

        // Clicks are NOT deduplicated.
        clickCount += 1

        AppLogger.info("Click Fired - position \(ad.position)")

        Task {
            await eventTracker.trackClick(for: ad)
        }
    }
}
