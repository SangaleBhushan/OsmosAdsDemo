//
//  LaunchView.swift
//  OsmosAdsDemo
//
//  Created by Bhushan Sangale on 22/09/26.
//

import SwiftUI

struct LaunchView: View {

    let onFinished: () -> Void

    @State private var progress: CGFloat = 0

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [ Color(red: 0.03, green: 0.07, blue: 0.22),Color(red: 0.02, green: 0.04, blue: 0.14)
],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {

                Spacer()

                // OSMOS Logo
                ZStack {

                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.cyan,
                                    Color.blue
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 18
                        )
                        .frame(width: 120,height: 120 )
                        .shadow(color: .cyan.opacity(0.35),radius: 18 )

                    Circle()
                        .fill( Color(red: 0.03,green: 0.07,blue: 0.22))
                        .frame(width: 82,height: 82)
                }

                VStack(spacing: 8) {

                    Text("OSMOS")
                        .font(.system(size: 38,weight: .bold))
                        .tracking(8)
                        .foregroundStyle(.white)

                    Text("ADS")
                        .font(.system(size: 18,weight: .semibold))
                        .tracking(5)
                        .foregroundStyle(.cyan)

                    Text("Display Ad Demo")
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.75))
                        .padding(.top, 4)
                }

                Spacer()

                VStack(spacing: 12) {

                    ZStack(alignment: .leading) {

                        Capsule()
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 180,height: 4)

                        Capsule()
                            .fill(.cyan)
                            .frame(width: 180 * progress,height: 4)
                    }

                    Text("Loading ads...")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.55) )
                }

                Spacer().frame(height: 50)
            }
            .padding(.horizontal, 24)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("OSMOS Ads. Loading display advertisements.")
        .task {

            withAnimation( .easeInOut(duration: 0.9)) {
                progress = 1
            }

            try? await Task.sleep( nanoseconds: 1_000_000_000)

            onFinished()
        }
    }
}
