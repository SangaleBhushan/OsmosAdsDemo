//
//  ShimmerView.swift
//  OsmosAdsDemo
//
//  Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {

    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {

        content
            .overlay {

                GeometryReader { geometry in

                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.5),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width)
                    .offset(
                        x: phase * geometry.size.width
                    )
                }
                .clipped()
            }
            .onAppear {

                withAnimation(
                    .linear(duration: 1.2)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {

    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
