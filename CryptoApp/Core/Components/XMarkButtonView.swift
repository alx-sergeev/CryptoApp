//
//  XMarkButtonView.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 10.10.2023.
//

import SwiftUI

struct XMarkButtonView: View {
    var dismissAction: (() -> ())?
    
    var body: some View {
        Button(action: {
            dismissAction?()
        }) {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

struct XMarkButtonView_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButtonView()
    }
}
