//
//  AirwallexApp.swift
//  Airwallex
//
//  Created by Clarence Chng on 1/7/25.
//

import SwiftUI

@main
struct AirwallexApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            
            let apiService = DogAPIService()
            let repository = DogRepository(apiService: apiService)
            let useCase = DogUseCase(repository: repository)
            DogView(useCase: useCase)
        }
    }
}
