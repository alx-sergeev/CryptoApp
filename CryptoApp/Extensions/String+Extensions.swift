//
//  String+Extensions.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 15.10.2023.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
