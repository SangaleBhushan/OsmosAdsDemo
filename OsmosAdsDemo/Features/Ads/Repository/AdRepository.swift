//
//  AdRepository.swift
//  OsmosAdsDemo
//
//  Created by Bhushan Sangale on 21/09/26.
//

import Foundation

protocol AdRepository: Sendable {
    func fetchAds() async throws -> [Ad]
}
