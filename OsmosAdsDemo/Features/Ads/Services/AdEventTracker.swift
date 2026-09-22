//
//  AdEventTracker.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import Foundation
import osmos

protocol AdEventTrackerProtocol: Sendable {
    func trackImpression(for ad: Ad) async
    func trackClick(for ad: Ad) async
}



final class AdEventTracker: AdEventTrackerProtocol {

    private let cliUbid = "Any"

    // MARK: - Impression

    func trackImpression( for ad: Ad) async {

        do {

            let osmosManager =   try OSMOS.shared()

            guard let registerEvent =   osmosManager.registerEvent()else {

                AppLogger.error( "Impression Failed - registerEvent unavailable" )

                return
            }

            let response = await registerEvent.registerAdImpressionEvent(
                cliUbid: cliUbid,
                uclid: ad.uclid,
                position: ad.position,
                onError: { error in
                    AppLogger.error("Impression Failed - \(error)")
                }
            )

            AppLogger.info("Impression response: \(String(describing: response))")

        } catch {

            AppLogger.error("Impression SDK error - \(error.localizedDescription)")
        }
    }

    // MARK: - Click

    func trackClick(for ad: Ad) async {

        do {

            let osmosManager = try OSMOS.shared()

            guard let registerEvent =  osmosManager.registerEvent()else {
                AppLogger.error("Click Failed - registerEvent unavailable")
                return
            }

            let response = await registerEvent.registerAdClickEvent(
                cliUbid: cliUbid,
                uclid: ad.uclid,
                trackingParams:TrackingParams(),
                onError: { error in
                    AppLogger.error( "Click Failed - \(error)")
                }
            )

            AppLogger.info( "Click response: \(String(describing: response))")

        } catch {
            AppLogger.error( "Click SDK error - \(error.localizedDescription)")
        }
    }
}
