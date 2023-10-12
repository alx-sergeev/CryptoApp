//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 12.10.2023.
//

import Foundation
import CoreData

class PortfolioDataService: ObservableObject {
    
    let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "Portfolio"
    
    @Published var entityItems: [Portfolio] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error.localizedDescription)")
            }
            
            self.fetchItems()
        }
    }
    
    // MARK: - Public
    
    func updatePortfolio(coin: Coin, amount: Double) {
        // check if coin is already in portfolio
        if let entity = entityItems.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: - Private
    
    private func fetchItems() {
        let request = NSFetchRequest<Portfolio>(entityName: entityName)
        
        do {
            entityItems = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error.localizedDescription)")
        }
    }
    
    private func add(coin: Coin, amount: Double) {
        let entity = Portfolio(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: Portfolio, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: Portfolio) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        fetchItems()
    }
}
