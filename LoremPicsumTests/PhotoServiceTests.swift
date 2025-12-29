//
//  PhotoServiceTests.swift
//  LoremPicsum
//
//  Created by Goran Gajduk on 29.12.25.
//


import XCTest
@testable import LoremPicsum

final class PhotoServiceTests: XCTestCase {
    
    var sut: PhotoService!
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        // Use ephemeral configuration to avoid caching between tests
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        sut = PhotoService(session: mockSession)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    
    func testFetchPhotos_Success_ReturnsPhotos() async throws {
        // Given: Mock successful response with valid JSON
        let mockPhotos = """
        [
            {
                "id": "0",
                "author": "Test Author",
                "width": 5000,
                "height": 3333,
                "url": "https://unsplash.com/photos/test",
                "download_url": "https://picsum.photos/id/0/5000/3333"
            },
            {
                "id": "1",
                "author": "Another Author",
                "width": 4000,
                "height": 2667,
                "url": "https://unsplash.com/photos/test2",
                "download_url": "https://picsum.photos/id/1/4000/2667"
            }
        ]
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockPhotos)
        }
        
        // When: Fetching photos
        let photos = try await sut.fetchPhotos()
        
        // Then: Should return 2 photos with correct data
        XCTAssertEqual(photos.count, 2)
        XCTAssertEqual(photos[0].id, "0")
        XCTAssertEqual(photos[0].author, "Test Author")
        XCTAssertEqual(photos[1].id, "1")
        XCTAssertEqual(photos[1].author, "Another Author")
    }
    
    func testFetchPhotos_WithPagination_BuildsCorrectURL() async throws {
        // Given: Mock response and capture the request
        var capturedRequest: URLRequest?
        let mockData = "[]".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            capturedRequest = request
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }
        
        // When: Fetching photos with pagination parameters
        _ = try await sut.fetchPhotos(page: 2, limit: 15)
        
        // Then: URL should contain correct query parameters
        let url = capturedRequest?.url
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.absoluteString.contains("page=2") ?? false)
        XCTAssertTrue(url?.absoluteString.contains("limit=15") ?? false)
    }
    
    // MARK: - Error Tests
    
    func testFetchPhotos_BadResponse_ThrowsBadResponseError() async {
        // Given: Mock 404 response
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        // When/Then: Should throw badResponse error
        do {
            _ = try await sut.fetchPhotos()
            XCTFail("Should have thrown badResponse error")
        } catch let error as PhotoServiceError {
            if case .badResponse(let statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            // Catch any other error types
            XCTFail("Unexpected error type thrown: \(error)")
        }
    }
    
    func testFetchPhotos_ServerError_ThrowsBadResponseError() async {
        // Given: Mock 500 server error
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        // When/Then: Should throw badResponse error
        do {
            _ = try await sut.fetchPhotos()
            XCTFail("Should have thrown badResponse error")
        } catch let error as PhotoServiceError {
            if case .badResponse(let statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            // Catch any other error types
            XCTFail("Unexpected error type thrown: \(error)")
        }
    }
    
    func testFetchPhotos_InvalidJSON_ThrowsDecodingError() async {
        // Given: Mock response with invalid JSON
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, invalidJSON)
        }
        
        // When/Then: Should throw decoding error
        do {
            _ = try await sut.fetchPhotos()
            XCTFail("Should have thrown decoding error")
        } catch let error as PhotoServiceError {
            if case .decoding = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            // Catch any other error types
            XCTFail("Unexpected error type thrown: \(error)")
        }
    }

    func testFetchPhotos_NetworkError_ThrowsNetworkError() async {
        // Given: Mock network error
        MockURLProtocol.requestHandler = { request in
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        }
        
        // When/Then: Should throw network error
        do {
            _ = try await sut.fetchPhotos()
            XCTFail("Should have thrown network error")
        } catch let error as PhotoServiceError {
            if case .network = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            // Catch any other error types
            XCTFail("Unexpected error type thrown: \(error)")
        }
    }

    func testFetchPhotos_MissingRequiredFields_ThrowsDecodingError() async {
        // Given: Mock response with missing required field
        let incompleteJSON = """
        [
            {
                "id": "0",
                "author": "Test Author"
            }
        ]
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, incompleteJSON)
        }
        
        // When/Then: Should throw decoding error
        do {
            _ = try await sut.fetchPhotos()
            XCTFail("Should have thrown decoding error")
        } catch let error as PhotoServiceError {
            if case .decoding = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            // Catch any other error types
            XCTFail("Unexpected error type thrown: \(error)")
        }
    }
    
    // MARK: - Edge Cases
    
    func testFetchPhotos_EmptyArray_ReturnsEmptyArray() async throws {
        // Given: Mock response with empty array
        let emptyJSON = "[]".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, emptyJSON)
        }
        
        // When: Fetching photos
        let photos = try await sut.fetchPhotos()
        
        // Then: Should return empty array
        XCTAssertTrue(photos.isEmpty)
    }
}

// MARK: - Mock URL Protocol

/// Mock URLProtocol to intercept network requests in tests
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is not set.")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // Required but no implementation needed
    }
}
