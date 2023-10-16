//
//  DetailView.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 14.10.2023.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    
    var body: some View {
        if let coin = coin {
            DetailView(coin: coin)
        }
    }
}

struct DetailView: View {
    @StateObject private var vm: DetailViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    overviewTitleView
                    Divider()
                    overviewContentView
                    
                    
                    additionalTitleView
                    Divider()
                    additionalContentView
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingView
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

// MARK: - Additional views
extension DetailView {
    private var navigationBarTrailingView: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.secondaryText)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitleView: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewContentView: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []
        ) {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalTitleView: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalContentView: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []
        ) {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
}
