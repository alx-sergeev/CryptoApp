//
//  CoinApiService.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 17.01.2024.
//

import Foundation
import Combine

final class ApiService {
    static let shared = ApiService()
    private init() {}
    
    
    @Published var allCoins: [Coin] = []
    private var coinSubscription: AnyCancellable?
    
    @Published var marketData: MarketData? = nil
    private var marketDataSubscription: AnyCancellable?
    
    @Published var coinDetail: CoinDetail?
    private var coin: Coin?
    private var coinDetailSubscription: AnyCancellable?
    
    
    func getCoins() {
        guard
            let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return
        }
        
        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
    
    func getMarketData() {
        guard
            let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return
        }
        
        marketDataSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
    
    func getCoinDetail(coin: Coin?) {
        self.coin = coin
        
        guard
            let url = URL(string: "https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return
        }
        
        coinDetailSubscription = NetworkManager.download(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetail) in
                self?.coinDetail = returnedCoinDetail
                self?.coinDetailSubscription?.cancel()
            })
    }
}
