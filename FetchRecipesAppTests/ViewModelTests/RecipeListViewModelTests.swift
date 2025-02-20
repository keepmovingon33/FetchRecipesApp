//
//  RecipeListViewModelTests.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Combine
@testable import FetchRecipesApp
import XCTest

final class RecipeListViewModelTests: XCTestCase {
    private enum Expected {
        static let count = 63
        static let recipe = Recipe(
            id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            cuisine: "Malaysian",
            name: "Apam Balik",
            largePhotoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"),
            smallPhotoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
            sourceURL: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ"),
            youtubeURL: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        )
        static let cuisineCount = 12
        static let cuisine = "American"
        static let errorMessage = "The data couldn’t be read because it is missing."
        static let filteredCount = 14
        static let filteredRecipe = Recipe(
            id: "f8b20884-1e54-4e72-a417-dabbc8d91f12",
            cuisine: "American",
            name: "Banana Pancakes",
            largePhotoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg"),
            smallPhotoURL: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg"),
            sourceURL: URL(string: "https://www.bbcgoodfood.com/recipes/banana-pancakes"),
            youtubeURL: URL(string: "https://www.youtube.com/watch?v=kSKtb2Sv-_U")
        )
    }
    
    private var subs = Set<AnyCancellable>()
    private var currentExpectation: XCTestExpectation?
    
    func testRecipeImageViewModel() {
        let sut = RecipeListViewModel(recipeService: DecodableRepository<RecipeList>(), imageService: ImageRepository())
        let viewModel = sut.recipeImageViewModel(for: Expected.recipe)
        XCTAssertEqual(viewModel.name, Expected.recipe.name)
        XCTAssertEqual(viewModel.cuisine, Expected.recipe.cuisine)
        XCTAssertEqual(viewModel.state, ImageState.loading)
    }
    
    func testFetchRecipesSuccess() async {
        let sut = RecipeListViewModel(recipeService: DecodableRepository<RecipeList>(networkService: MockNetworkService()), imageService: ImageRepository())
        
        var currentRecipes: [Recipe] = []
        let expectation = XCTestExpectation()
        sut.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .loaded(let recipes):
                    currentRecipes = recipes
                    expectation.fulfill()
                default:
                    XCTFail("No other state should be reached")
                }
            }
            .store(in: &subs)
        
        await sut.fetchRecipes(for: MockEnvironment.recipeList.request)
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.state, RecipeListState.loaded([]))
        XCTAssertEqual(currentRecipes.count, Expected.count)
        XCTAssertEqual(currentRecipes.first, Expected.recipe)
        XCTAssertEqual(sut.highlightButtonViewModels.count, Expected.cuisineCount)
        XCTAssertEqual(sut.highlightButtonViewModels.first?.label, Expected.cuisine)
    }
    
    func testFetchEmptyRecipes() async {
        let sut = RecipeListViewModel(recipeService: DecodableRepository<RecipeList>(networkService: MockNetworkService()), imageService: ImageRepository())
        
        let expectation = XCTestExpectation()
        sut.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .empty:
                    expectation.fulfill()
                default:
                    XCTFail("No other state should be reached")
                }
            }
            .store(in: &subs)
        
        await sut.fetchRecipes(for: MockEnvironment.emptyList.request)
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.state, RecipeListState.empty)
        XCTAssertTrue(sut.highlightButtonViewModels.isEmpty)
    }
    
    func testFetchRecipesFailure() async {
        let sut = RecipeListViewModel(recipeService: DecodableRepository<RecipeList>(networkService: MockNetworkService()), imageService: ImageRepository())
        
        var currentError: Error?
        let expectation = XCTestExpectation()
        sut.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .error(let error):
                    currentError = error
                    expectation.fulfill()
                default:
                    XCTFail("No other state should be reached")
                }
            }
            .store(in: &subs)
        
        await sut.fetchRecipes(for: MockEnvironment.errorList.request)
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.state, RecipeListState.error(NSError(domain: "", code: 0)))
        XCTAssertEqual((currentError as? DecodingError)?.localizedDescription, Expected.errorMessage)
        XCTAssertTrue(sut.highlightButtonViewModels.isEmpty)
    }
    
    func testRetryFetchRecipes() async {
        let sut = RecipeListViewModel(recipeService: DecodableRepository<RecipeList>(networkService: MockNetworkService()), imageService: ImageRepository())
        
        var currentRecipes: [Recipe] = []
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        sut.$state
            .dropFirst()
            .sink { state in
                switch state {
                case .loading:
                    expectation.fulfill()
                case .loaded(let recipes):
                    currentRecipes = recipes
                    expectation.fulfill()
                default:
                    XCTFail("No other state should be reached")
                }
            }
            .store(in: &subs)
        
        await sut.retryFetchRecipes(for: MockEnvironment.recipeList.request)
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.state, RecipeListState.loaded([]))
        XCTAssertEqual(currentRecipes.count, Expected.count)
        XCTAssertEqual(currentRecipes.first, Expected.recipe)
        XCTAssertEqual(sut.highlightButtonViewModels.count, Expected.cuisineCount)
        XCTAssertEqual(sut.highlightButtonViewModels.first?.label, Expected.cuisine)
    }
    
    func testUpdateFilter() async {
        let sut = RecipeListViewModel(recipeService: DecodableRepository<RecipeList>(networkService: MockNetworkService()), imageService: ImageRepository())
        
        var currentRecipes: [Recipe] = []
        let fetchExpectation = XCTestExpectation()
        sut.$state
            .dropFirst()
            .sink { [weak self] state in
                switch state {
                case .loaded(let recipes):
                    currentRecipes = recipes
                    guard let currentExpectation  = self?.currentExpectation else {
                        XCTFail("Expectation should exist")
                        return
                    }
                    currentExpectation.fulfill()
                default:
                    XCTFail("No other state should be reached")
                }
            }
            .store(in: &subs)
        
        currentExpectation = fetchExpectation
        await sut.fetchRecipes(for: MockEnvironment.recipeList.request)
        await fulfillment(of: [fetchExpectation])
        XCTAssertEqual(sut.state, RecipeListState.loaded([]))
        XCTAssertEqual(currentRecipes.count, Expected.count)
        XCTAssertEqual(currentRecipes.first, Expected.recipe)
        // Filter
        let filteredExpectation = XCTestExpectation()
        currentExpectation = filteredExpectation
        await sut.updateFilter(with: Expected.cuisine)
        await fulfillment(of: [filteredExpectation])
        XCTAssertEqual(sut.state, RecipeListState.loaded([]))
        XCTAssertEqual(currentRecipes.count, Expected.filteredCount)
        XCTAssertEqual(currentRecipes.first, Expected.filteredRecipe)
        // Unfilter
        let unfilteredExpectation = XCTestExpectation()
        currentExpectation = unfilteredExpectation
        await sut.updateFilter(with: Expected.cuisine)
        await fulfillment(of: [unfilteredExpectation])
        XCTAssertEqual(sut.state, RecipeListState.loaded([]))
        XCTAssertEqual(currentRecipes.count, Expected.count)
        XCTAssertEqual(currentRecipes.first, Expected.recipe)
    }
}
