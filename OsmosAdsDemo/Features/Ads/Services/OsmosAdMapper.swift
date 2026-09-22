//
//  OsmosAdMapper.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import Foundation

enum OsmosAdMapper {

    static func map(_ response: [String: Any]) throws -> [Ad] {

        guard  let responseData = response["response"] as? [String: Any] else {
            throw OsmosSDKError.invalidResponse
        }

        guard let dataString = responseData["data"] as? String, let data = dataString.data(using: .utf8) else {
            throw OsmosSDKError.invalidResponse
        }

        let json: Any

        do {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            throw OsmosSDKError.invalidResponse
        }

        guard let root = json as? [String: Any] else {
            throw OsmosSDKError.invalidResponse
        }

        guard let ads = root["ads"] as? [String: Any], let bannerAds =  ads["banner_ads"] as? [[String: Any]] else {
            return []
        }

        return bannerAds.enumerated().compactMap { index,banner in

            guard let elements = banner["elements"] as? [String: Any], let rawValue = elements["value"] as? String,let rawUclid = banner["uclid"] as? String else {
                AppLogger.warning("Skipping malformed OSMOS banner at index \(index)")
                return nil
            }

            let value = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)

            let uclid = rawUclid.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !value.isEmpty, !uclid.isEmpty, let imageURL = URL(string: value) else {
                AppLogger.warning("Skipping malformed OSMOS banner at index \(index)")
                return nil
            }

            let destinationString = (elements["destination_url"] as? String) ?? ( banner["destination_url"] as? String)

            let destinationURL = destinationString.flatMap {
                        URL(string:$0.trimmingCharacters( in:.whitespacesAndNewlines))
                    }

            let impressionTrackingURL =  (banner["impression_tracking_url"] as? String).flatMap(URL.init)

            let clickTrackingURL = (banner["click_tracking_url"] as? String).flatMap(URL.init)

            let width = elements["width"] as? Int ?? 0

            let height = elements["height"] as? Int ?? 0

            let position = banner["rank"] as? Int ?? index + 1

            return Ad(
                id: uclid,
                imageURL: imageURL,
                destinationURL: destinationURL,
                impressionTrackingURL:impressionTrackingURL,
                clickTrackingURL: clickTrackingURL,
                uclid: uclid,
                position: position,
                width: width,
                height: height
            )
        }
    }
}
