//
//  OsmosAdsDemoTests.swift
//  OsmosAdsDemoTests
//
//  Created by Bhushan Sangale on 21/09/26.
//

import XCTest
@testable import OsmosAdsDemo

final class OsmosAdsDemoTests: XCTestCase {

    func testMapperMapsBannerAd() throws {

        let response: [String: Any] = [

            "response": [

                "code": 200,
                "data": """
                {
                    "ads": {
                        "banner_ads": [
                            {
                                "rank": 1,
                                "uclid": "test-uclid",
                                "elements": {
                                    "type": "IMAGE",
                                    "value": "https://example.com/ad.jpg",
                                    "width": 200,
                                    "height": 200,
                                    "destination_url": "https://example.com/offer"
                                },
                                "impression_tracking_url": "https://example.com/impression",
                                "click_tracking_url": "https://example.com/click"
                            }
                        ]
                    }
                }
                """
            ]
        ]

        let ads = try OsmosAdMapper.map(response)

        XCTAssertEqual(ads.count, 1)
        XCTAssertEqual(ads[0].uclid, "test-uclid")
        XCTAssertEqual(ads[0].position, 1)
        XCTAssertEqual(ads[0].width, 200)
        XCTAssertEqual(ads[0].height, 200)
        XCTAssertEqual(ads[0].imageURL,URL(string: "https://example.com/ad.jpg"))
        XCTAssertEqual(ads[0].destinationURL,URL(string: "https://example.com/offer"))
        XCTAssertEqual(ads[0].impressionTrackingURL,URL(string: "https://example.com/impression"))
        XCTAssertEqual(ads[0].clickTrackingURL,URL(string: "https://example.com/click"))
    }
    func testMapperSkipsAdWhenElementsAreMissing() throws {

        let response: [String: Any] = [
            "response": [
                "code": 200,
                "data": """
                {
                    "ads": {
                        "banner_ads": [
                            {
                                "rank": 1,
                                "uclid": "test-uclid"
                            }
                        ]
                    }
                }
                """
            ]
        ]

        let ads = try OsmosAdMapper.map(response)

        XCTAssertTrue(ads.isEmpty)
    }
    func testMapperReturnsEmptyArrayWhenNoBannerAds() throws {
        let response: [String: Any] = [
            "response": [
                "code": 200,
                "data": "{\"ads\":{\"banner_ads\":[]}}"
            ]
        ]

        let ads = try OsmosAdMapper.map(response)

        XCTAssertTrue(ads.isEmpty)
    }

    func testMapperAllowsMissingDestinationURL() throws {
        let response: [String: Any] = [
            "response": [
                "code": 200,
                "data": """
                {"ads":{"banner_ads":[{"rank":1,"uclid":"test-uclid","elements":{"type":"IMAGE","value":"https://example.com/ad.jpg","width":200,"height":200}}]}}
                """
            ]
        ]

        let ads = try OsmosAdMapper.map(response)

        XCTAssertEqual(ads.count, 1)
        XCTAssertNil(ads[0].destinationURL)
        XCTAssertFalse(ads[0].hasDestination)
    }

    @MainActor
    func testImpressionIsTrackedOnlyOncePerAd() async {
        let repository = MockAdRepository(result: .success([TestFixtures.ad]))
        let tracker = MockAdEventTracker()
        let viewModel = AdsViewModel(
            repository: repository,
            eventTracker: tracker
        )

        viewModel.handleVisibility(for: TestFixtures.ad, isVisible: true)
        viewModel.handleVisibility(for: TestFixtures.ad, isVisible: true)

        XCTAssertEqual(viewModel.impressionCount, 1)

        // Allow the fire-and-forget tracking task to execute.
        try? await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(tracker.impressionCalls, 1)
    }

    @MainActor
    func testEveryClickIsCounted() async {
        let repository = MockAdRepository(result: .success([TestFixtures.ad]))
        let tracker = MockAdEventTracker()
        let viewModel = AdsViewModel(
            repository: repository,
            eventTracker: tracker
        )

        viewModel.handleClick(for: TestFixtures.ad)
        viewModel.handleClick(for: TestFixtures.ad)

        XCTAssertEqual(viewModel.clickCount, 2)

        try? await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(tracker.clickCalls, 2)
    }
    func testMapperSkipsAdWhenImageValueIsMissing() throws {

        let response: [String: Any] = [
            "response": [
                "code": 200,
                "data": """
                {
                    "ads": {
                        "banner_ads": [
                            {
                                "rank": 1,
                                "uclid": "test-uclid",
                                "elements": {
                                    "width": 200,
                                    "height": 200
                                }
                            }
                        ]
                    }
                }
                """
            ]
        ]

        let ads = try OsmosAdMapper.map(response)

        XCTAssertTrue(ads.isEmpty)
    }
    func testMapperSkipsAdWhenImageURLIsEmpty() throws {

        let response: [String: Any] = [
            "response": [
                "code": 200,
                "data": """
                {
                    "ads": {
                        "banner_ads": [
                            {
                                "rank": 1,
                                "uclid": "test-uclid",
                                "elements": {
                                    "type": "IMAGE",
                                    "value": "",
                                    "width": 200,
                                    "height": 200
                                }
                            }
                        ]
                    }
                }
                """
            ]
        ]

        let ads = try OsmosAdMapper.map(response)

        XCTAssertTrue(ads.isEmpty)
    }
    func testMapperSkipsAdWhenUclidIsMissing() throws {

        let response: [String: Any] = [
            "response": [
                "code": 200,
                "data": """
                {
                    "ads": {
                        "banner_ads": [
                            {
                                "rank": 1,
                                "elements": {
                                    "type": "IMAGE",
                                    "value": "https://example.com/ad.jpg",
                                    "width": 200,
                                    "height": 200
                                }
                            }
                        ]
                    }
                }
                """
            ]
        ]

        let ads = try OsmosAdMapper.map(response)

        XCTAssertTrue(ads.isEmpty)
    }
    func testMapperSkipsAdWhenUclidIsEmpty() throws {

        let response: [String: Any] = [
            "response": [
                "code": 200,
                "data": """
                {
                    "ads": {
                        "banner_ads": [
                            {
                                "rank": 1,
                                "uclid": "",
                                "elements": {
                                    "type": "IMAGE",
                                    "value": "https://example.com/ad.jpg",
                                    "width": 200,
                                    "height": 200
                                }
                            }
                        ]
                    }
                }
                """
            ]
        ]

        let ads = try OsmosAdMapper.map(response)

        XCTAssertTrue(ads.isEmpty)
    }
    func testMapperThrowsForInvalidJSON() {

        let response: [String: Any] = [
            "response": [
                "code": 200,
                "data": "this is not valid json"
            ]
        ]

        XCTAssertThrowsError(try OsmosAdMapper.map(response) ) { error in
            XCTAssertEqual(error as? OsmosSDKError, .invalidResponse)
        }
    }
    func testMapperKeepsValidAdsAndSkipsMalformedAds() throws {

        let response: [String: Any] = [
            "response": [
                "code": 200,
                "data": """
                {
                    "ads": {
                        "banner_ads": [

                            {
                                "rank": 1,
                                "uclid": "valid-ad",
                                "elements": {
                                    "type": "IMAGE",
                                    "value": "https://example.com/ad.jpg",
                                    "width": 200,
                                    "height": 200
                                }
                            },

                            {
                                "rank": 2,
                                "uclid": "",
                                "elements": {
                                    "type": "IMAGE",
                                    "value": "https://example.com/bad.jpg",
                                    "width": 200,
                                    "height": 200
                                }
                            }

                        ]
                    }
                }
                """
            ]
        ]

        let ads = try OsmosAdMapper.map(response)

        XCTAssertEqual(ads.count, 1)
        XCTAssertEqual(ads.first?.uclid, "valid-ad")
    }
    
    @MainActor
    func testLoadAdsStoresFetchedAds() async {

        let repository = MockAdRepository(result: .success([TestFixtures.ad ]))
        let tracker = MockAdEventTracker()
        let viewModel = AdsViewModel(repository: repository,eventTracker: tracker)
        await viewModel.loadAds()
        XCTAssertEqual(viewModel.ads.count,1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage )
    }
    
    @MainActor
    func testLoadAdsHandlesEmptyResponse() async {

        let repository = MockAdRepository(result: .success([]))
        let tracker = MockAdEventTracker()
        let viewModel = AdsViewModel(repository: repository,eventTracker: tracker)
        await viewModel.loadAds()
        XCTAssertTrue(viewModel.ads.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    

    @MainActor
    func testRefreshFailureKeepsExistingAds() async {

        let repository = SequentialMockAdRepository(
            results: [.success([TestFixtures.ad]),.failure(  URLError(.notConnectedToInternet))]
        )

        let tracker = MockAdEventTracker()
        let viewModel = AdsViewModel( repository: repository,eventTracker: tracker)
        await viewModel.loadAds()
        XCTAssertEqual(viewModel.ads.count,1)

        await viewModel.loadAds()

        XCTAssertEqual(viewModel.ads.count,1)

        XCTAssertNotNil(viewModel.errorMessage)
    }

}

private enum TestFixtures {

    static let ad = Ad(
        id: "test-uclid",
        imageURL: URL(string: "https://example.com/ad.jpg")!,
        destinationURL: URL(string: "https://example.com/offer"),
        impressionTrackingURL: nil,
        clickTrackingURL: nil,
        uclid: "test-uclid",
        position: 1,
        width: 200,
        height: 200
    )
}

private final class MockAdEventTracker: AdEventTrackerProtocol, @unchecked Sendable {

    private(set) var impressionCalls = 0
    private(set) var clickCalls = 0

    func trackImpression(for ad: Ad) async {
        impressionCalls += 1
    }

    func trackClick(for ad: Ad) async {
        clickCalls += 1
    }
}

final class SequentialMockAdRepository: AdRepository {

    private var results: [Result<[Ad], Error>]
    private var index = 0

    init(results: [Result<[Ad], Error>]) {
        self.results = results
    }

    func fetchAds() async throws -> [Ad] {

        let result = results[index]
        index += 1

        return try result.get()
    }
}
