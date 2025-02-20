//
//  RecipeHighlightButtonViewModelTests.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Combine
@testable import FetchRecipesApp
import XCTest

final class RecipeHighlightButtonViewModelTests: XCTestCase {
    private enum Expected {
        static let label = "label"
        static let index = 0
        static let action: () -> Void = { }
    }
    
    private var subs = Set<AnyCancellable>()
    private var currentExpectation: XCTestExpectation?
    
    func testViewModelValues() {
        let sut = RecipeHighlightButtonViewModel(label: Expected.label, index: Expected.index, action: Expected.action)
        
        XCTAssertEqual(sut.label, Expected.label)
        XCTAssertEqual(sut.index, Expected.index)
        
        let expectationToggleOff = XCTestExpectation()
        let expectationToggleOn = XCTestExpectation()
        
        var boundValue: Bool?
        sut.$isSelected
            .dropFirst()
            .sink { [weak self] value in
                boundValue = value
                guard let currentExpectation  = self?.currentExpectation else {
                    XCTFail("Expectation should exist")
                    return
                }
                currentExpectation.fulfill()
            }
            .store(in: &subs)
        
        currentExpectation = expectationToggleOn
        sut.isSelected.toggle()
        wait(for: [expectationToggleOn], timeout: 0.1)
        XCTAssertEqual(boundValue, true)

        currentExpectation = expectationToggleOff
        sut.isSelected.toggle()
        wait(for: [expectationToggleOff], timeout: 0.1)
        XCTAssertEqual(boundValue, false)
    }

}
