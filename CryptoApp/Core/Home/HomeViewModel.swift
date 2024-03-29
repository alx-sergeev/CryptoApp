//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 14.09.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    private let apiService = ApiService.shared
    private let porftolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchText = ""
    @Published var statistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var sortOption: SortOption = .holdingDesc
    
    
    init() {
        startup()
    }
    
    
    private func startup() {
        apiService.getCoins()
        apiService.getMarketData()
        addSubscribers()
    }
    
    private func addSubscribers() {
        // updates allCoins
        $searchText
            .combineLatest(apiService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates portfolioCoins
        $allCoins
            .combineLatest(porftolioDataService.$entityItems)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // updates marketData
        apiService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions
extension HomeViewModel {
    func updatePorftolio(coin: Coin, amount: Double) {
        porftolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        apiService.getCoins()
        apiService.getMarketData()
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { coin -> Bool in
            return
                coin.name.lowercased().contains(lowercasedText) ||
                coin.symbol.lowercased().contains(lowercasedText) ||
                coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rankAsc, .holdingDesc:
            coins.sort(by: {$0.rank < $1.rank })
        case .rankDesc, .holdingAsc:
            coins.sort(by: {$0.rank > $1.rank })
        case .priceAsc:
            coins.sort(by: {$0.currentPrice < $1.currentPrice })
        case .priceDesc:
            coins.sort(by: {$0.currentPrice > $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        // will only sort by holdingAsc or holdingDesk if needed
        switch sortOption {
        case .holdingAsc:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        case .holdingDesc:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioEntities: [Portfolio]) -> [Coin] {
        allCoins
            .compactMap { coin -> Coin? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketData: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketData else {
            return stats
        }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)
        let previousPortfolioValue = portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentChange)
                
                return previousValue
            }
            .reduce(0, +)
        let percentagePortfolioChange = ((portfolioValue - previousPortfolioValue) / previousPortfolioValue) * 100
        
        let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentagePortfolioChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
}

extension HomeViewModel {
    enum SortOption {
        case rankAsc, rankDesc, priceAsc, priceDesc, holdingAsc, holdingDesc
    }
}
