//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 14.09.2023.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.allCoins.append(DeveloperPreview.shared.coin)
            self.portfolioCoins.append(DeveloperPreview.shared.coin)
        }
    }
}
