//
//  HomeStatsView.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 10.10.2023.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    
    @Binding var showPortfolio: Bool
    
    
    var body: some View {
        HStack {
            ForEach(homeVM.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width,
            alignment: showPortfolio ? .trailing : .leading
        )
        .padding(.vertical)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
