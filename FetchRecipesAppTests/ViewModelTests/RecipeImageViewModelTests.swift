//
//  RecipeImageViewModelTests.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Combine
@testable import FetchRecipesApp
import XCTest

final class RecipeImageViewModelTests: XCTestCase {
    private enum Expected {
        static let recipe = Recipe(
            id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            cuisine: "Malaysian",
            name: "Apam Balik",
            largePhotoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"),
            smallPhotoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
            sourceURL: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ"),
            youtubeURL: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        )
        static let imageData = UIImage(systemName: "xmark")?.jpegData(compressionQuality: 1) ?? Data()
    }
    
    private var subs = Set<AnyCancellable>()
    private var currentExpectation: XCTestExpectation?
    
    func testViewModelValues() {
        let sut = RecipeImageViewModel(imageService: ImageRepository(), recipe: Expected.recipe)
        XCTAssertEqual(sut.name, Expected.recipe.name)
        XCTAssertEqual(sut.cuisine, Expected.recipe.cuisine)
    }
    
    func testViewModelFetchImageSuccess() async {
        let sut = RecipeImageViewModel(imageService: ImageRepository(networkService: MockNetworkService(imageData: Expected.imageData)), recipe: Expected.recipe)
        
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        sut.$state
            .dropFirst()
            .sink { state in
                expectation.fulfill()
            }
            .store(in: &subs)
        
        await sut.fetchImage()
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.state, ImageState.loaded(UIImage()))
    }
    
    func testViewModelFetchImageFailure() async {
        let sut = RecipeImageViewModel(imageService: ImageRepository(networkService: MockNetworkService()), recipe: Expected.recipe)
        
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        sut.$state
            .dropFirst()
            .sink { state in
                expectation.fulfill()
            }
            .store(in: &subs)
        
        await sut.fetchImage()
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.state, ImageState.error(NSError(domain: "", code: 0)))
    }

}
