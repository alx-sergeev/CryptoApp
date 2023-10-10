//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 10.10.2023.
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketData: MarketData? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    
    init() {
        getMarketData()
    }
    
    
    private func getMarketData() {
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
}
