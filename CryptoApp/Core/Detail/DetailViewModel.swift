//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 15.10.2023.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    private let apiService = ApiService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var coin: Coin
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    @Published var description: String?
    @Published var websiteURL: String?
    @Published var redditURL: String?
    
    init(coin: Coin) {
        self.coin = coin
        self.apiService.getCoinDetail(coin: coin)
        
        addSubscribers()
    }
    
    private func addSubscribers() {
        apiService.$coinDetail
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        apiService.$coinDetail
            .sink { [weak self] (returnedCoinDetail) in
                self?.description = returnedCoinDetail?.readableDescription
                self?.websiteURL = returnedCoinDetail?.links?.homepage?.first
                self?.redditURL = returnedCoinDetail?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions
extension DetailViewModel {
    private func mapDataToStatistics(coinDetail: CoinDetail?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
            let overviewArray = createOverviewArray(coin: coin)
            let additionalArray = createAdditionalArray(coinDetail: coinDetail, coin: coin)
            return (overviewArray, additionalArray)
        }
        
        private func createOverviewArray(coin: Coin) -> [Statistic] {
            let price = coin.currentPrice.asCurrencyWith6Decimals()
            let pricePercentChange = coin.priceChangePercentage24H
            let priceStat = Statistic(title: "Current Price", value: price, percentageChange: pricePercentChange)
            
            let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
            let marketCapPercentChange = coin.marketCapChangePercentage24H
            let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
            
            let rank = "\(coin.rank)"
            let rankStat = Statistic(title: "Rank", value: rank)
            
            let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
            let volumeStat = Statistic(title: "Volume", value: volume)
            
            let overviewArray: [Statistic] = [
                priceStat, marketCapStat, rankStat, volumeStat
            ]
            return overviewArray
        }
        
        private func createAdditionalArray(coinDetail: CoinDetail?, coin: Coin) -> [Statistic] {
            
            let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
            let highStat = Statistic(title: "24h High", value: high)
            
            let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
            let lowStat = Statistic(title: "24h Low", value: low)
            
            let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
            let pricePercentChange = coin.priceChangePercentage24H
            let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
            
            let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
            let marketCapPercentChange = coin.marketCapChangePercentage24H
            let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
            
            let blockTime = coinDetail?.blockTimeInMinutes ?? 0
            let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
            let blockStat = Statistic(title: "Block Time", value: blockTimeString)
            
            let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
            let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
            
            let additionalArray: [Statistic] = [
                highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
            ]
            return additionalArray
        }
}
