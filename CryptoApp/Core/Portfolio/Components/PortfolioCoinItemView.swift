//
//  CoinPortfolioView.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 10.10.2023.
//

import SwiftUI

struct PortfolioCoinItemView: View {
    let coin: Coin
    
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text(coin.name)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioCoinItemView(coin: dev.coin)
    }
}
