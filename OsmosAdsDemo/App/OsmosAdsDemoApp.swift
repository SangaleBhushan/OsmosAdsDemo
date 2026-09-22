//
//  OsmosAdsDemoApp.swift
//  OsmosAdsDemo
//
//  Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

@main
struct OsmosAdsDemoApp: App {

    private let container: AppContainer

    @State private var showLaunchScreen = true

    init() {

        let result = OsmosSDKConfiguration.initialize()

        switch result {

        case .success:

            self.container = AppContainer(sdkState: .initialized )

        case .failure:

            self.container = AppContainer(sdkState: .failed )
        }
    }

    var body: some Scene {

        WindowGroup {

            Group {

                if showLaunchScreen {

                    LaunchView {

                        withAnimation(.easeOut(duration: 0.25)) {
                            showLaunchScreen = false
                        }
                    }

                } else {

                    AdsView(repository: container.adRepository,eventTracker:container.adEventTracker)
                }
            }
        }
    }
}
