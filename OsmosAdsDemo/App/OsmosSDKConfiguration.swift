//
//  OsmosSDKConfiguration.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import Foundation
import osmos

enum OsmosSDKConfiguration {
   
    enum InitializationResult {
        case success
        case failure(Error)
    }
    
    
    static func initialize() -> InitializationResult {

        do {

            try OSMOS.Builder()
                .clientId("10088010")
                .debug(true)
                .displayAdsHost("demo-ba.o-s.io")
                .productAdsHost("demo.o-s.io")
                .buildGlobalInstance()

            AppLogger.info("OSMOS SDK initialized successfully")

            return .success

        } catch {

            AppLogger.error("OSMOS SDK initialization failed - \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
}
