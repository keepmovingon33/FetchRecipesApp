//
//  ImageRepositoryTests.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

@testable import FetchRecipesApp
import XCTest

final class ImageRepositoryTests: XCTestCase {
    private enum Expected {
        static let imageURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
        static let imageData = UIImage(systemName: "xmark")?.jpegData(compressionQuality: 1) ?? Data()
    }

    func testFetchImageFromNetwork() async {
        let sut = ImageRepository(networkService: MockNetworkService(imageData: Expected.imageData), cache: DataCache())
        do {
            let image = try await sut.fetch(for: MockEnvironment.image(Expected.imageURL).request)
            // Due to conversions to images and back, bytes get lost/added. Applying accuracy of +/- 25 bytes
            XCTAssertEqual(Double(image.jpegData(compressionQuality: 1)?.count ?? 0), Double(Expected.imageData.count), accuracy: 25)
        } catch {
            XCTFail("Image Should NOT fail to fetch")
        }
    }
    
    func testFetchImageCached() async {
        let cache = DataCache()
        cache.setData(Expected.imageData, for: Expected.imageURL?.absoluteString ?? "")
        let sut = ImageRepository(networkService: MockNetworkService(), cache: cache)
        do {
            let image = try await sut.fetch(for: MockEnvironment.image(Expected.imageURL).request)
            // Due to conversions to images and back, bytes get lost/added. Applying accuracy of +/- 25 bytes
            XCTAssertEqual(Double(image.jpegData(compressionQuality: 1)?.count ?? 0), Double(Expected.imageData.count), accuracy: 25)
        } catch {
            XCTFail("Image Should NOT fail to fetch")
        }
    }
    
    func testFetchImageFailure() async {
        let sut = ImageRepository(networkService: MockNetworkService(), cache: DataCache())
        do {
            let _ = try await sut.fetch(for: MockEnvironment.image(Expected.imageURL).request)
            XCTFail("Image Should fail to fetch")
        } catch {
            XCTAssertEqual(error as? ImageRepositoryError, ImageRepositoryError.invalidImage)
        }
    }
}
