//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 17.10.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let defaultURL: URL! = URL(string: "https://www.google.com")
    private let githubURL: URL! = URL(string: "https://github.com/alx-sergeev")
    private let coingeckoURL: URL! = URL(string: "https://www.coingecko.com")
    
    var body: some View {
        NavigationView {
            List {
                aboutSectionView
                    .listRowBackground(Color.theme.background.opacity(0.5))
                coinGeckoSectionView
                    .listRowBackground(Color.theme.background.opacity(0.5))
                applicationSectionView
                    .listRowBackground(Color.theme.background.opacity(0.5))
            }
            .listStyle(.grouped)
            .tint(.blue)
            .font(.headline)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButtonView {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

// MARK: - Sections
extension SettingsView {
    private var aboutSectionView: some View {
        Section(content: {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was made by Alexander Sergeev. It uses MVVM Architecture, Combine, CoreData. October, 2023.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            
            Link("My github @alx-sergeev", destination: githubURL)
        }, header: {
            Text("About mobile app")
        })
    }
    
    private var coinGeckoSectionView: some View {
        Section(content: {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit CoinGecko", destination: coingeckoURL)
        }, header: {
            Text("Coingecko")
        })
    }
    
    private var applicationSectionView: some View {
        Section(content: {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        }, header: {
            Text("Application")
        })
    }
}
