//
//  QuizCompletionView.swift
//  Airwallex
//
//  Created by Clarence Chng on 2/7/25.
//

import SwiftUI

struct QuizCompletionView: View {
    let score: Int
    let total: Int
    let celebrationScale: CGFloat
    let onPlayAgain: () -> Void
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.9)
                .ignoresSafeArea(.all)
                .animation(.easeInOut(duration: 0.3), value: true)
            
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Text("🎊")
                        .font(.system(size: 80))
                        .scaleEffect(celebrationScale)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: celebrationScale)
                    
                    Text("Quiz Complete!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Here's how you did:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 24) {
                    Text("Your Score")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("\(score)")
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                        
                        Text("/")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text("\(total)")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                )
                
                VStack(spacing: 16) {
                    Button(action: {
                        onPlayAgain()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.clockwise")
                                .font(.headline)
                            Text("Play Again")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .blue.opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 40)
            
        }
    }
}

#Preview {
//    QuizCompletionView()
}
