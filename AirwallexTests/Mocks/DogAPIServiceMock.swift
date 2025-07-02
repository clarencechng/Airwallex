//
//  DogAPIServiceMock.swift
//  AirwallexTests
//
//  Created by Clarence Chng on 2/7/25.
//

import Foundation
@testable import Airwallex

final class DogAPIServiceMock: DogAPIServiceProtocol {
    var mockDogBreed: DogBreed = DogBreed(message: [:], status: "success")
    var mockImageURL: String = "https://example.com/mock.jpg"

    var shouldThrow: Bool = false

    func fetchDogBreed() async throws -> DogBreed {
        if shouldThrow {
            throw URLError(.badURL)
        }
        return mockDogBreed
    }

    func fetchDogImageURL(breed: String, subType: String?) async throws -> String {
        if shouldThrow {
            throw URLError(.badURL)
        }
        return mockImageURL
    }
}
