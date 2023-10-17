//
//  HomeView.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 12.09.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    @State private var showPortfolio = false // animation right
    @State private var showPortfolioView = false // new sheet
    @State private var showSettingsView = false // new sheet
    
    @State private var selectedCoin: Coin?
    @State private var showDetailVeiw = false
    
    var body: some View {
        ZStack {
            // Background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(viewModel)
                }
            
            // Content layer
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $viewModel.searchText)
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                } else {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer()
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin), isActive: $showDetailVeiw) {
                EmptyView()
            }
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}

// MARK: - Additional views
extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .animation(.none, value: showPortfolio)
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none, value: showPortfolio)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    DispatchQueue.main.async {
                        withAnimation(.spring()) {
                            showPortfolio.toggle()
                        }
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.reloadData()
        }
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.reloadData()
        }
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                
                Image(systemName: "chevron.down")
                    .opacity(
                        (viewModel.sortOption == .rankAsc || viewModel.sortOption == .rankDesc) ?
                        1 : 0
                    )
                    .rotationEffect(
                        Angle(degrees: viewModel.sortOption == .rankAsc ? 180 : 0 )
                    )
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = (viewModel.sortOption == .rankAsc) ? .rankDesc : .rankAsc
                }
            }
            
            Spacer()
            
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    
                    Image(systemName: "chevron.down")
                        .opacity(
                            (viewModel.sortOption == .holdingAsc || viewModel.sortOption == .holdingDesc) ?
                            1 : 0
                        )
                        .rotationEffect(
                            Angle(degrees: viewModel.sortOption == .holdingAsc ? 180 : 0 )
                        )
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = (viewModel.sortOption == .holdingAsc) ? .holdingDesc : .holdingAsc
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                
                Image(systemName: "chevron.down")
                    .opacity(
                        (viewModel.sortOption == .priceAsc || viewModel.sortOption == .priceDesc) ?
                        1 : 0
                    )
                    .rotationEffect(
                        Angle(degrees: viewModel.sortOption == .priceAsc ? 180 : 0 )
                    )
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = (viewModel.sortOption == .priceAsc) ? .priceDesc : .priceAsc
                }
            }
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
        .padding(.top)
    }
}

// MARK: - Actions
extension HomeView {
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailVeiw.toggle()
    }
}
