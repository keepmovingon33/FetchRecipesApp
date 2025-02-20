//
//  DecodableRepositoryTests.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

@testable import FetchRecipesApp
import XCTest

final class DecodableRepositoryTests: XCTestCase {
    private enum Expected {
        static let count = 63
        static let errorMessage = "The data couldn’t be read because it is missing."
        static let recipe = Recipe(
            id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            cuisine: "Malaysian",
            name: "Apam Balik",
            largePhotoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"),
            smallPhotoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
            sourceURL: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ"),
            youtubeURL: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        )
    }
    
    func testFetchRecipes() async {
        let sut = DecodableRepository<RecipeList>(networkService: MockNetworkService())
        do {
            let recipeList = try await sut.fetch(for: MockEnvironment.recipeList.request)
            XCTAssertEqual(recipeList.recipes.count, Expected.count)
            XCTAssertEqual(recipeList.recipes.first, Expected.recipe)
        } catch {
            XCTFail("Request should have fetched RecipeList")
        }
    }
    
    func testFetchMalformedRecipes() async {
        let sut = DecodableRepository<RecipeList>(networkService: MockNetworkService())
        do {
            let _ = try await sut.fetch(for: MockEnvironment.errorList.request)
            XCTFail("Request should have failed to fetch recipeList")
        } catch {
            XCTAssertEqual((error as? DecodingError)?.localizedDescription, Expected.errorMessage)
        }
    }
}
