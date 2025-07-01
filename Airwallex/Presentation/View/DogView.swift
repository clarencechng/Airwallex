//
//  DogView.swift
//  Airwallex
//
//  Created by Clarence Chng on 1/7/25.
//

import SwiftUI

struct Question {
    let imageName: String
    let options: [String]
    let correctAnswerIndex: Int
    
    func isCorrect(selectedIndex: Int) -> Bool {
        return selectedIndex == correctAnswerIndex
    }
}

struct DogView: View {
    @StateObject private var viewModel: DogViewModel
    
    init(useCase: DogUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: DogViewModel(useCase: useCase))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 10) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        dogImageView
                        questionView
                        answerOptionsView
                        
                        if viewModel.showResult {
                            nextButtonView
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 24)
                }
            }
            
            if viewModel.showCelebration {
                celebrationOverlay
            }
        }
        .onAppear() {
            viewModel.onAppear()
        }
        .preferredColorScheme(.light)
    }
    
    private var headerView: some View {
        HStack {
            HStack(spacing: 8) {
                Text("Guess the Breed!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                // Score
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text("\(viewModel.score)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.1), radius: 2)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    private var dogImageView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                .frame(height: 320)
            
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .frame(height: 280)
                    .overlay(
                        VStack {
                            if let imageURL = viewModel.currentQuestionData?.imageName,
                               let url = URL(string: imageURL) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                }
                            } else {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                        }
                    )
                    .padding(16)
            }
        }
    }
    
    private var questionView: some View {
        VStack(spacing: 8) {
            Text("What breed is this adorable pup?")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Take your best guess!")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }
    
    private var answerOptionsView: some View {
        VStack(spacing: 16) {
            if let currentQuestion = viewModel.currentQuestionData {
                ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                    answerButton(for: option, index: index, currentQuestion: currentQuestion)
                }
            }
        }
    }
    
    private func answerButton(for option: String, index: Int, currentQuestion: Question) -> some View {
        let backgroundColor = backgroundColorForOption(at: index, currentQuestion: currentQuestion)
        let textColor = textColorForOption(at: index, currentQuestion: currentQuestion)
        let shadowColor = shadowColorForOption(at: index, currentQuestion: currentQuestion)
        let shadowRadius = shadowRadiusForOption(at: index, currentQuestion: currentQuestion)
        let isCorrect = currentQuestion.isCorrect(selectedIndex: index)
        let isSelected = viewModel.selectedAnswerIndex == index
        let isWrong = isSelected && !isCorrect
        
        return Button(action: {
            if !viewModel.showResult {
                viewModel.handleAnswer(selectedIndex: index)
            }
        }) {
            HStack {
                Text(option)
                    .font(.body)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if viewModel.showResult {
                    if isCorrect {
                        Image(systemName: "checkmark")
                            .font(.title3)
                            .foregroundColor(.white)
                    } else if isWrong {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: shadowColor, radius: shadowRadius)
        }
        .disabled(viewModel.showResult)
        .animation(.spring(response: 0.3), value: viewModel.showResult)
    }
    
    private var nextButtonView: some View {
        Button(action: viewModel.nextQuestion) {
            Text(viewModel.currentQuestion < viewModel.questions.count - 1 ? "Next Question" : "Restart Quiz")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .scaleEffect(viewModel.showResult ? 1.0 : 0.95)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.showResult)
    }
    
    private var celebrationOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.showCelebration = false
                }
            
            VStack(spacing: 16) {
                Text("🎉")
                    .font(.system(size: 60))
                    .scaleEffect(viewModel.celebrationScale)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.celebrationScale)
                
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
        .onAppear {
            viewModel.celebrationScale = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                viewModel.showCelebration = false
            }
        }
        .onDisappear {
            viewModel.celebrationScale = 0.1
        }
    }
    
    private func backgroundColorForOption(at index: Int, currentQuestion: Question) -> Color {
        if !viewModel.showResult {
            return Color.white
        } else if currentQuestion.isCorrect(selectedIndex: index) {
            return Color.green
        } else if viewModel.selectedAnswerIndex == index && !currentQuestion.isCorrect(selectedIndex: index) {
            return Color.red
        } else {
            return Color.gray.opacity(0.2)
        }
    }
    
    private func textColorForOption(at index: Int, currentQuestion: Question) -> Color {
        if !viewModel.showResult {
            return Color.primary
        } else if currentQuestion.isCorrect(selectedIndex: index) ||
                    (viewModel.selectedAnswerIndex == index && !currentQuestion.isCorrect(selectedIndex: index)) {
            return Color.white
        } else {
            return Color.gray
        }
    }
    
    private func shadowColorForOption(at index: Int, currentQuestion: Question) -> Color {
        if !viewModel.showResult {
            return Color.black.opacity(0.1)
        } else if currentQuestion.isCorrect(selectedIndex: index) {
            return Color.green.opacity(0.3)
        } else if viewModel.selectedAnswerIndex == index && !currentQuestion.isCorrect(selectedIndex: index) {
            return Color.red.opacity(0.3)
        } else {
            return Color.clear
        }
    }
    
    private func shadowRadiusForOption(at index: Int, currentQuestion: Question) -> CGFloat {
        if !viewModel.showResult {
            return 2
        } else if currentQuestion.isCorrect(selectedIndex: index) ||
                    (viewModel.selectedAnswerIndex == index && !currentQuestion.isCorrect(selectedIndex: index)) {
            return 8
        } else {
            return 0
        }
    }
}

#Preview {
//    DogView()
}
