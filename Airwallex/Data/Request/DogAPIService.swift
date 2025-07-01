//
//  DogAPIService.swift
//  Airwallex
//
//  Created by Clarence Chng on 1/7/25.
//

import Foundation

protocol DogAPIServiceProtocol {
    func fetchDogBreed() async throws -> DogBreed
    func fetchDogImageURL(breed: String, subType: String?) async throws -> String
}

final class DogAPIService: DogAPIServiceProtocol {
    func fetchDogBreed() async throws -> DogBreed {
        let urlString = "https://dog.ceo/api/breeds/list/all"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(DogBreed.self, from: data)
        return decodedData
    }
    
    func fetchDogImageURL(breed: String, subType: String?) async throws -> String {
        let urlString: String
        if let subType = subType {
            urlString = "https://dog.ceo/api/breed/\(breed)/\(subType)/images/random"
        } else {
            urlString = "https://dog.ceo/api/breed/\(breed)/images/random"
        }
        
        guard let url = URL(string: urlString) else {
            return ""
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return ""
        }
        
        let decodedData = try JSONDecoder().decode(DogImage.self, from: data)
        return decodedData.message
    }
}
