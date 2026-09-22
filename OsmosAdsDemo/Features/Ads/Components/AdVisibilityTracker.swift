//
//  AdVisibilityTracker.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//


/// Reusable visibility modifier that reports when at least `threshold`
/// of the modified view's visible area is inside the screen viewport.

import SwiftUI

struct AdVisibilityTracker: ViewModifier {

    let threshold: CGFloat
    let onVisible: () -> Void

    func body(content: Content) -> some View {

        content
            .background {
                GeometryReader { geometry in

                    Color.clear
                        .onAppear {
                            checkVisibility(frame: geometry.frame(in: .global))
                        }.onChange(of: geometry.frame(in: .global)) { newFrame in
                            checkVisibility(frame: newFrame)
                        }
                }
            }
    }

    private func checkVisibility(frame: CGRect ) {

        guard frame.width > 0,frame.height > 0 else {
            return
        }

        let screenBounds =   UIScreen.main.bounds

        let visibleRect =  frame.intersection(screenBounds)

        guard !visibleRect.isNull else {
            return
        }

        let visibleArea =  visibleRect.width * visibleRect.height

        let totalArea = frame.width * frame.height

        guard totalArea > 0 else {
            return
        }

        let visibleRatio = visibleArea / totalArea

        guard visibleRatio >= threshold else {
            return
        }

        // ViewModel handles deduplication.
        onVisible()
    }
}

extension View {

    func trackVisibility( threshold: CGFloat = 0.5, onVisible: @escaping () -> Void) -> some View {
        modifier(AdVisibilityTracker( threshold: threshold,onVisible: onVisible))
    }
}
