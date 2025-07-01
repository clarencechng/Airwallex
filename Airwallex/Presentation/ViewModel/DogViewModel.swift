//
//  DogViewModel.swift
//  Airwallex
//
//  Created by Clarence Chng on 1/7/25.
//

import Foundation

@MainActor
final class DogViewModel: ObservableObject {
    
    @Published var currentQuestion = 0
    @Published var score = 0
    @Published var showResult = false
    @Published var selectedAnswerIndex: Int? = nil
    @Published var showCelebration = false
    @Published var celebrationScale: CGFloat = 0.1
    
    @Published var isLoading = false
    @Published var loadingError: String? = nil
    @Published var questions: [Question] = []
    
    @Published var dogsData: DogBreed? = nil
    @Published var formattedDogBreeds: [(String, String?)] = []
    @Published var chosenDogs: [(String, String?)] = []
    
    
    var isDataReady: Bool {
        !isLoading && !questions.isEmpty && loadingError == nil
    }
    
    var currentQuestionData: Question? {
        guard !questions.isEmpty, currentQuestion < questions.count else {
            return nil
        }
        return questions[currentQuestion]
    }
    
    private let useCase: DogUseCaseProtocol
    
    init(useCase: DogUseCaseProtocol) {
        self.useCase = useCase
    }
    
    private func getDogBreed() async {
        isLoading = true
        loadingError = nil
        questions = []
        
        Task {
            do {
                let data = try await useCase.getDogBreed()
                dogsData = data
                
                try await handleData()
                
                isLoading = false
            } catch {
                // Handle error here
                loadingError = "Failed to load data. Please try again."
                isLoading = false
            }
        }
    }
    
    private func dogBreedFormatter(breed: String, subType: String?) -> String {
        if let subType, !subType.isEmpty {
            return "\(subType) \(breed)"
        } else {
            return breed
        }
    }
    
    private func handleData() async throws  {
        guard let dogsData else {
            loadingError = "Failed to load data. Please try again."
            isLoading = false
            
            return
        }
        
        formattedDogBreeds = []
        
        for (breed, subtypes) in dogsData.message {
            if subtypes.isEmpty {
                formattedDogBreeds.append((breed, nil))
            } else {
                for subtype in subtypes {
                    formattedDogBreeds.append((breed, subtype))
                }
            }
        }
        
        chosenDogs = Array(formattedDogBreeds.shuffled().prefix(10))
        
        for (breed, subType) in chosenDogs {
            let imageURL = try await useCase.getDogImageURL(breed: breed, subType: subType)
            
            let correctAnswer = dogBreedFormatter(breed: breed, subType: subType)
            
            let incorrectOptions = formattedDogBreeds
                .filter { dogBreedFormatter(breed: $0.0, subType: $0.1) != correctAnswer }
                .map { dogBreedFormatter(breed: $0.0, subType: $0.1) }
                .shuffled().prefix(3)
            
            let correctAnswerIndex = Int.random(in: 0...3)
            var options = Array(incorrectOptions)
            options.insert(correctAnswer, at: correctAnswerIndex)
            
            let question = Question(
                imageName: imageURL,
                options: options,
                correctAnswerIndex: correctAnswerIndex
            )
            
            questions.append(question)
        }
    }
    
    func onAppear() {
        if questions.isEmpty {
            Task { await getDogBreed() }
        }
    }
    
    func handleAnswer(selectedIndex: Int) {
        selectedAnswerIndex = selectedIndex
        showResult = true
        
        if selectedIndex == currentQuestionData?.correctAnswerIndex {
            score += 1
            showCelebration = true
        }
    }
    
    func nextQuestion() {
        if currentQuestion < questions.count - 1 {
            currentQuestion += 1
        } else {
            currentQuestion = 0
        }
        showResult = false
    }
    
    func resetQuiz() {
        currentQuestion = 0
        score = 0
        showResult = false
        showCelebration = false
    }
}
