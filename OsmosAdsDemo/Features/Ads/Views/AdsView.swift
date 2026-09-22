//
//  AdsView.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

struct AdsView: View {

    @State private var viewModel: AdsViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL
    @State private var showMissingDestinationAlert = false

    init(repository: any AdRepository,eventTracker: any AdEventTrackerProtocol) {
        _viewModel = State(initialValue:AdsViewModel(repository: repository,eventTracker: eventTracker))
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading,spacing: AppSpacing.xxl) {

                    AdHeaderView()

                    AdStatsView(loaded: viewModel.loadedCount,impressions:viewModel.impressionCount,clicks:viewModel.clickCount)

                    VStack(alignment: .leading,spacing: AppSpacing.md) {

                        Text("DISPLAY ADS")
                            .font(.system(size: 12,weight: .bold))
                            .tracking(1)
                            .foregroundStyle(AppColors.secondary)

                        if viewModel.isLoading {

                            AdLoadingView()
                            AdLoadingView()

                        } else if viewModel.ads.isEmpty {

                            AdEmptyView {

                                Task {
                                    await viewModel.loadAds()
                                }
                            }

                        } else {

                            // Refresh error while
                            // keeping currently loaded ads.
                            if let error = viewModel.errorMessage {

                                HStack(spacing: AppSpacing.md) {

                                    Image(systemName:"exclamationmark.triangle")

                                    Text(error).font(.system(size: 13, weight: .medium ))

                                    Spacer()
                                }
                                .foregroundStyle(AppColors.error)
                                .padding(14)
                                .background( AppColors.error.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.small))
                            }

                            LazyVStack(spacing: AppSpacing.xl) {

                                ForEach( viewModel.ads) { ad in

                                    AdCardView(ad: ad) {
                                        handleAdTap(ad)
                                    }.trackVisibility( threshold: 0.5) { 
                                        viewModel.handleVisibility(for: ad,isVisible:true)
                                    }
                                }
                            }
                        }
                    }

                    PrimaryButton(title: viewModel.isLoading ? "Loading..."  : "Load Ad",icon: "arrow.clockwise"){
                        Task {
                            await viewModel.loadAds()
                        }
                    }
                    .disabled(viewModel.isLoading)
                    .opacity(viewModel.isLoading ? 0.6 : 1  )
                }
                .padding(.horizontal, 20)
                .padding(.top, AppRadius.medium)
                .padding(.bottom, 32)
            }
            .background(AppColors.background)
            .refreshable {
                await viewModel.loadAds()
            }
            .navigationBarHidden(true)
        }

        .alert("Destination Unavailable", isPresented:   $showMissingDestinationAlert) {

            Button("OK", role: .cancel) {}

        } message: {

            Text( "The ad click was tracked, but this ad does not currently provide a destination URL.")
        }.task {
            await viewModel.loadAds()
            
        }.onChange(of: scenePhase) {
            guard scenePhase == .active else {
                return
            }

            guard viewModel.ads.isEmpty else {
                return
            }

            guard !viewModel.isLoading else {
                return
            }

            Task {
                await viewModel.loadAds()
            }
        }
    }

    // MARK: - Click Handling

    private func handleAdTap(_ ad: Ad) {
        viewModel.handleClick(for: ad)
        guard let destinationURL = ad.destinationURL else {
            showMissingDestinationAlert =  true
            return
        }

        openURL(destinationURL)
    }
}
