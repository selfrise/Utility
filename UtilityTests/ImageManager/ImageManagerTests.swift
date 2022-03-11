//
//  ImageManagerTests.swift
//  UtilityTests
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import XCTest
@testable import Utility

final class ImageManagerTests: XCTestCase {
    private var sut: ImageManager!
    private var imageId = "1234"
    
    override func setUp() {
        sut = ImageManager.shared
    }
    
    func testSaveWithBase64() throws {
        //Given
        let exp = expectation(description: "Save Image")
        let imageData = try XCTUnwrap(Data(base64Encoded: MockImageManager.base64Encoded225x225))
        
        //When
        sut.save(id: imageId, imageData: imageData) { (state) in
            XCTAssertTrue(state)
            exp.fulfill()
        }
        
        //Then
        wait(for: [exp], timeout: 0.5)
    }
    
    func testGetImage() throws {
        //Given
        let exp = expectation(description: "Get Image")
        let imageData = try XCTUnwrap(Data(base64Encoded: MockImageManager.base64Encoded225x225))
        let saveImageExpectation = expectation(description: "Save Image")
        
        sut.save(id: imageId, imageData: imageData) { (saved) in
            XCTAssertTrue(saved)
            saveImageExpectation.fulfill()
        }
        
        wait(for: [saveImageExpectation], timeout: 0.5)
        
        //When
        sut.get(id: imageId) { (savedImage) in
            XCTAssertNotNil(savedImage)
            guard case .value(let image) = savedImage else {
                XCTAssert(false, "Image is invalid")
                return
            }
            
            XCTAssertEqual(imageData, image)
            exp.fulfill()
        }
        
        //Then
        wait(for: [exp], timeout: 0.5)
    }
    
    func testRemove() {
        //Given
        let exp = expectation(description: "Remove Image")
        
        //When
        sut.remove(forKey: imageId)
        
        //Then
        sut.get(id: imageId) { (result) in
            XCTAssertEqual(result, .none)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }
    
    func testGetImageWithWrongURL() {
        // Given
        let imageURL = ""
        let exp = expectation(description: "Get Image")
        
        // When
        sut.get(with: imageURL) { result in
            XCTAssertEqual(result, .none)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.5)
    }
}

enum MockImageManager {
    static var base64Encoded225x225: String {
        "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"
    }
}
