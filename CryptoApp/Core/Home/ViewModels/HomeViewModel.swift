//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 14.09.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let porftolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchText = ""
    
    @Published var statistics: [Statistic] = []
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    
    init() {
        addSubscribers()
    }
    
    
    private func addSubscribers() {
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
        // updates portfolioCoins
        $allCoins
            .combineLatest(porftolioDataService.$entityItems)
            .map { (coins, portfolioEntities) -> [Coin] in
                coins
                    .compactMap { coin -> Coin? in
                        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePorftolio(coin: Coin, amount: Double) {
        porftolioDataService.updatePortfolio(coin: coin, amount: amount)
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
    
    private func mapGlobalMarketData(marketData: MarketData?) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketData else {
            return stats
        }
        
        let marketCap = Statistic(title: "Рыночная капитализация", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "Объем за 24 часа", value: data.volume)
        let btcDominance = Statistic(title: "Доминирующий BTC", value: data.btcDominance)
        let portfolio = Statistic(title: "Стоимость портфеля", value: "\u{20BD}0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
}
