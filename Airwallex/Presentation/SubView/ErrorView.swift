//
//  ErrorView.swift
//  Airwallex
//
//  Created by Clarence Chng on 2/7/25.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    let retryAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.9)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 32) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                
                Text("Something went wrong!")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Button("Try Again") {
                    retryAction()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(Color.blue)
                .clipShape(Capsule())
            }
        }
    }
}

#Preview {
//    ErrorView()
}
