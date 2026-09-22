//
//  AdHeaderView.swift
//  OsmosAdsDemo
//
//  Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

struct AdHeaderView: View {

    var body: some View {
        HStack(alignment: .top) {

            VStack(alignment: .leading, spacing: 6) {

                Text("Osmos")
                    .font(.system(size: 30, weight: .bold))

                Text("Ad Experience")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.secondary)
            }

            Spacer()

            Circle()
                .fill(AppColors.success.opacity(0.15))
                .frame(width: 42, height: 42)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(AppColors.success)
                }
        }
    }
}

#Preview {
    AdHeaderView().padding()
}
