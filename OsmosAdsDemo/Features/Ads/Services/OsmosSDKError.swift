//
//  OsmosSDKError.swift
//  OsmosAdsDemo
//
//  Created by Bhushan Sangale on 21/09/26.
//

import Foundation

enum OsmosSDKError: LocalizedError, Equatable {

    case initializationFailed
    case adFetcherUnavailable
    case emptyResponse
    case invalidResponse
    case missingRequiredField

    var errorDescription: String? {

        switch self {

        case .initializationFailed:
            return "Advertisement service could not be initialized."

        case .adFetcherUnavailable:
            return "Ad service is currently unavailable."

        case .emptyResponse:
            return "No ad response was received."

        case .invalidResponse:
            return "The ad response was invalid."

        case .missingRequiredField:
            return "Required ad information is missing."
        }
    }
}
