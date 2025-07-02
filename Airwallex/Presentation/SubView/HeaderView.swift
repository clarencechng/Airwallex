//
//  HeaderView.swift
//  Airwallex
//
//  Created by Clarence Chng on 2/7/25.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let currentQuestion: Int
    let totalQuestions: Int
    let score: Int
    let onReset: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Text("Guess the Breed!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                // Counter
                HStack(spacing: 4) {
                    Image(systemName: "list.number")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text("\(currentQuestion + 1)/\(totalQuestions)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .clipShape(Capsule())
                
                // Score
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text("\(score)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.1), radius: 2)
            }
            
            // Reset
            HStack(spacing: 12) {
                Button(action: {
                    onReset()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(8)
                .background(Color.red.opacity(0.1))
                .clipShape(Circle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
}

#Preview {
//    HeaderView()
}
