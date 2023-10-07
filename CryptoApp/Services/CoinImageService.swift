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
    private let fileManager = LocaleFileManager.shared
    private let folderName = "coin_images"
    private let imageName: String
    
    @Published var image: UIImage?
    
    
    init(coin: Coin) {
        self.coin = coin
        
        imageName = coin.id
        getCoinImage()
    }
    
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap { (data) -> UIImage? in
                return UIImage(data: data)
            }
            .sink(receiveCompletion: NetworkManager.handleCompletion) { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            }
    }
}
