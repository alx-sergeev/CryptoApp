//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 05.10.2023.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    private let coin: Coin
    private var imageSubscription: AnyCancellable?
    
    @Published var image: UIImage?
    
    
    init(coin: Coin) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap { (data) -> UIImage? in
                return UIImage(data: data)
            }
            .sink(receiveCompletion: NetworkManager.handleCompletion) { [weak self] (returnedImage) in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            }
    }
}
