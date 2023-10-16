//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 15.10.2023.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetail: CoinDetail?
    let coin: Coin
    
    var coinDetailSubscription: AnyCancellable?
    
    
    init(coin: Coin) {
        self.coin = coin
        
        getCoinDetail()
    }
    
    
    func getCoinDetail() {
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
