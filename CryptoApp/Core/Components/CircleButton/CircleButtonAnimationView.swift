//
//  CircleButtonAnimationView.swift
//  CryptoApp
//
//  Created by Сергеев Александр on 12.09.2023.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool
    
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 2)
            .scale(animate ? 1.5 : 0)
            .opacity(animate ? 0 : 1)
            .animation(animate ? .easeOut(duration: 1) : .none, value: animate)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
    }
}
