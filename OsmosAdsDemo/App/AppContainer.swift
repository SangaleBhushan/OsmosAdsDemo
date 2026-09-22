//
//  AppContainer.swift
//  OsmosAdsDemo
//
//  Created by Bhushan Sangale on 21/09/26.
//

import Foundation

@MainActor
final class AppContainer {

    let adRepository: any AdRepository
    let adEventTracker: any AdEventTrackerProtocol
    let sdkState: OsmosSDKState

    init(sdkState: OsmosSDKState) {

        self.sdkState = sdkState

        switch sdkState {

        case .initialized:

            let sdkService = OsmosSDKService()

            self.adRepository = OsmosAdRepository(sdkService: sdkService)

            self.adEventTracker = AdEventTracker()

        case .failed:

            self.adRepository = FailedAdRepository(error:OsmosSDKError.initializationFailed)

            self.adEventTracker = AdEventTracker()
        }
    }
}
