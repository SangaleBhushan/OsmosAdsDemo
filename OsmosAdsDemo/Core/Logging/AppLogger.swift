//
//  AppLogger.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import OSLog

/// Lightweight application logger used instead of raw `print` statements.

enum AppLogger {

    private static let logger = Logger(subsystem: "OsmosAdsDemo",category: "Ads")

    static func info( _ message: String) {
        logger.info( "\(message, privacy: .public)" )
    }

    static func error(_ message: String) {
        logger.error( "\(message, privacy: .public)" )
    }

    static func debug(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }
    static func warning(_ message:String){
        logger.warning("\(message, privacy: .public)")
    }
}
