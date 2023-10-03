//
//  Training.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 26.09.2023.
//

import SwiftUI

struct NewTitle: Codable {
    let name: String
}

class TrainingViewModel: ObservableObject {
    @Published var title: String?
    
    
    init() {
        self.getData()
    }
    
    
    private func getData() {
        let newTitle = NewTitle(name: "Hello world!")
        
        if let data = try? JSONEncoder().encode(newTitle.self),
           let result = try? JSONDecoder().decode(NewTitle.self, from: data) {
            self.title = result.name
        }
    }
}

struct Training: View {
    @StateObject var vm = TrainingViewModel()
    
    
    var body: some View {
        Text(vm.title ?? "")
            .font(.largeTitle)
    }
}

struct Training_Previews: PreviewProvider {
    static var previews: some View {
        Training()
    }
}
