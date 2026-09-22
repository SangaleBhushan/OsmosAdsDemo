//
//  Ad.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import Foundation

struct Ad: Identifiable, Equatable, Sendable {

    let id: String
    let imageURL: URL
    let destinationURL: URL?
    let impressionTrackingURL: URL?
    let clickTrackingURL: URL?
    let uclid: String
    let position: Int
    let width: Int
    let height: Int

    var hasDestination: Bool {
        destinationURL != nil
    }
}
