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

    @Published var showQuizComplete = false
    
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
}

// MARK: Public

extension DogViewModel {
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
            showResult = false
        } else {
            currentQuestion = 0
            showQuizComplete = true
        }
    }
    
    func resetQuiz() {
        currentQuestion = 0
        score = 0
        showResult = false
        showCelebration = false
        showQuizComplete = false
        
        Task {
            await getDogBreed()
        }
    }
}

// MARK: Private

extension DogViewModel {
    private func getDogBreed() async {
        isLoading = true
        loadingError = nil
        questions = []
        
        Task {
            do {
                let data = try await useCase.getDogBreed()
                try await handleData(dogsData: data)
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
    
    private func handleData(dogsData: DogBreed?) async throws {
        guard let dogsData else {
            loadingError = "Failed to load data. Please try again."
            isLoading = false
            return
        }

        var formattedDogBreeds: [(String, String?)] = []

        for (breed, subtypes) in dogsData.message {
            if subtypes.isEmpty {
                formattedDogBreeds.append((breed, nil))
            } else {
                for subtype in subtypes {
                    formattedDogBreeds.append((breed, subtype))
                }
            }
        }

        let chosenDogs = Array(formattedDogBreeds.shuffled().prefix(10))
        let allBreedsFormatted = formattedDogBreeds.map { dogBreedFormatter(breed: $0.0, subType: $0.1) }

        try await withThrowingTaskGroup(of: Question?.self) { group in
            for (breed, subType) in chosenDogs {
                group.addTask {
                    let imageURL = try await self.useCase.getDogImageURL(breed: breed, subType: subType)
                    let correctAnswer = await self.dogBreedFormatter(breed: breed, subType: subType)

                    let incorrectOptions = allBreedsFormatted
                        .filter { $0 != correctAnswer }
                        .shuffled()
                        .prefix(3)

                    var options = Array(incorrectOptions)
                    let correctAnswerIndex = Int.random(in: 0...3)
                    options.insert(correctAnswer, at: correctAnswerIndex)

                    return Question(
                        imageName: imageURL,
                        options: options,
                        correctAnswerIndex: correctAnswerIndex
                    )
                }
            }

            for try await question in group {
                if let q = question {
                    questions.append(q)
                }
            }
        }
    }
}
