//
//  Coin.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 12.09.2023.
//

import Foundation

// CoinGecko API info
/*
URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=rub&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 
JSON Response:
 {
         "id": "bitcoin",
         "symbol": "btc",
         "name": "Bitcoin",
         "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
         "current_price": 2461209,
         "market_cap": 47954253311273,
         "market_cap_rank": 1,
         "fully_diluted_valuation": 51687241245359,
         "total_volume": 1925093098084,
         "high_24h": 2475391,
         "low_24h": 2384288,
         "price_change_24h": -1617.8394470443018,
         "price_change_percentage_24h": -0.06569,
         "market_cap_change_24h": -64782795732.828125,
         "market_cap_change_percentage_24h": -0.13491,
         "circulating_supply": 19483325.0,
         "total_supply": 21000000.0,
         "max_supply": 21000000.0,
         "ath": 6075508,
         "ath_change_percentage": -59.49526,
         "ath_date": "2022-03-07T16:43:46.826Z",
         "atl": 2206.43,
         "atl_change_percentage": 111431.52825,
         "atl_date": "2013-07-05T00:00:00.000Z",
         "roi": null,
         "last_updated": "2023-09-12T12:08:59.303Z",
         "sparkline_in_7d": {
             "price": [
                 25765.384374327292,
                 25806.529233946632,
             ]
         },
         "price_change_percentage_24h_in_currency": -0.06569035179271045
     }
 */

struct Coin: Identifiable, Codable, Equatable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
    struct SparklineIn7D: Codable {
        let price: [Double]?
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func updateHoldings(amount: Double) -> Self {
        Coin(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingsValue: Double {
        (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        Int(marketCapRank ?? 0)
    }
}
