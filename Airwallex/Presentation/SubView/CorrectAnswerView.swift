//
//  CorrectAnswerView.swift
//  Airwallex
//
//  Created by Clarence Chng on 2/7/25.
//

import SwiftUI

struct CorrectAnswerView: View {
    let celebrationScale: CGFloat
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 16) {
                Text("🎉")
                    .font(.system(size: 60))
                    .scaleEffect(celebrationScale)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: celebrationScale)
                
                Text("🎉 Congratulations! 🎉")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Text("Correct Answer!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(32)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.2), radius: 20)
        }
    }
}

#Preview {
//    CorrectAnswerView()
}
