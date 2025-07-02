//
//  DogViewModelXCTest.swift
//  AirwallexTests
//
//  Created by Clarence Chng on 2/7/25.
//

import XCTest
@testable import Airwallex

final class DogViewModelTests: XCTestCase {
    var viewModel: DogViewModel!
    var apiServiceMock: DogAPIServiceMock!

    override func setUp() async throws {
        try await super.setUp()
        
        apiServiceMock = DogAPIServiceMock()
        apiServiceMock.mockDogBreed = DogBreed(
            message: [
                "retriever": ["golden", "labrador", "chesapeake"],
                "terrier": ["american", "australian", "bedlington", "border"],
                "spaniel": ["blenheim", "brittany", "cocker", "irish", "japanese"],
                "sheepdog": ["english", "shetland"],
                "mastiff": ["bull", "english", "tibetan"],
                "hound": ["afghan", "basset", "blood", "english"],
                "bulldog": ["boston", "english", "french"],
                "poodle": ["miniature", "standard", "toy"],
                "collie": ["border"],
                "schnauzer": ["giant", "miniature"],
                "pointer": ["german", "english"],
                "cattledog": ["australian"],
                "eskimo": [],
                "husky": [],
                "akita": [],
                "boxer": [],
                "chow": [],
                "dalmatian": [],
                "doberman": [],
                "pug": []
            ],
            status: "success"
        )
        apiServiceMock.mockImageURL = "https://example.com/mock.jpg"
        
        let repository = DogRepositoryMock(apiService: apiServiceMock)
        let useCase = DogUseCaseMock(repository: repository)
        viewModel = await DogViewModel(useCase: useCase)
    }
    
    func test_fetchData_apiError_shouldShowError() async {
        // Given
        let apiService = DogAPIServiceMock()
        apiService.shouldThrow = true
        
        let repo = DogRepositoryMock(apiService: apiService)
        let useCase = DogUseCaseMock(repository: repo)
        let viewModel = await DogViewModel(useCase: useCase)
        
        // When
        await viewModel.onAppear()
        
        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.loadingError, "Failed to load data. Please try again.")
            XCTAssertTrue(viewModel.questions.isEmpty)
            XCTAssertFalse(viewModel.isLoading)
        }
    }
    
    func test_onAppear_loadsQuestions() async {
        // When
        await viewModel.onAppear()
        
        // Then
        await MainActor.run {
            XCTAssertFalse(viewModel.questions.isEmpty)
            XCTAssertEqual(viewModel.questions.count, 10)
            XCTAssertEqual(viewModel.questions.first?.imageName, "https://example.com/mock.jpg")
        }
    }
    
    func test_handleAnswer_correctAnswer_shouldincreasesScore() async {
        await MainActor.run {
            // Given
            viewModel.questions = [
                Question(imageName: "url", options: ["a", "b", "c", "d"], correctAnswerIndex: 2)
            ]
            
            // When
            viewModel.handleAnswer(selectedIndex: 2)
            
            // Then
            XCTAssertEqual(viewModel.score, 1)
            XCTAssertTrue(viewModel.showCelebration)
            XCTAssertTrue(viewModel.showResult)
        }
    }
    
    func test_handleAnswer_wrongAnswer_shouldNotIncreaseScore() async {
        await MainActor.run {
            // Given
            viewModel.questions = [
                Question(imageName: "url", options: ["a", "b", "c", "d"], correctAnswerIndex: 2)
            ]
            
            // When
            viewModel.handleAnswer(selectedIndex: 0)
            
            // Then
            XCTAssertEqual(viewModel.score, 0)
            XCTAssertFalse(viewModel.showCelebration)
            XCTAssertTrue(viewModel.showResult)
        }
    }
    
    func test_nextQuestion_advancesIndex() async {
        await MainActor.run {
            // Given
            viewModel.questions = Array(repeating: Question(imageName: "url", options: ["a", "b", "c", "d"], correctAnswerIndex: 0), count: 3)
            
            // When
            viewModel.nextQuestion()
            // Then
            XCTAssertEqual(viewModel.currentQuestion, 1)
            
            // When
            viewModel.nextQuestion()
            // Then
            XCTAssertEqual(viewModel.currentQuestion, 2)
            
            // When
            viewModel.nextQuestion()
            // Then
            XCTAssertEqual(viewModel.currentQuestion, 0)
            XCTAssertTrue(viewModel.showQuizComplete)
        }
    }
    
    func test_resetQuiz_resetsState() async {
        // Given
        
        await MainActor.run {
            viewModel.score = 5
            viewModel.currentQuestion = 3
            viewModel.showResult = true
            viewModel.showCelebration = true
            viewModel.showQuizComplete = true
        }
        
        // When
        await viewModel.resetQuiz()
        
        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.currentQuestion, 0)
            XCTAssertEqual(viewModel.score, 0)
            XCTAssertFalse(viewModel.showResult)
            XCTAssertFalse(viewModel.showCelebration)
            XCTAssertFalse(viewModel.showQuizComplete)
            XCTAssertFalse(viewModel.questions.isEmpty)
        }
    }
}
