//
//  MovieBrowserApiTests.swift
//  MovieBrowserApiTests
//
//  Created by Adrian Inculet on 10.12.2025.
//

import XCTest
@testable import MovieBrowserApi

final class ApiServiceTests: XCTestCase {
    var sut: ApiService!
    var mockSession: URLSession!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        sut = ApiService(urlSession: mockSession)
    }
    
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        sut = nil
        mockSession = nil
        super.tearDown()
    }
    
    func test_fetchMovies_returnMovieResponse_onSuccess() async throws {
        let expectedMovie = MovieListItem(title: "Spiderman: No Way Home", imdbID: "tt10872600", year: 2021, posterURL: "mock_url", rank: 1)
        let mockResponse = MovieResponse(ok: true, errorCode: 0, description: [expectedMovie])
        let mockData = try JSONEncoder().encode(mockResponse)
        
        MockURLProtocol.requestHandler = { request in
            guard request.url?.query?.contains("q=Spiderman") == true else {
                throw NetworkError.invalidURL
            }
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockData)
        }
        let result = try await sut.fetchMovies(searchTerm: "Spiderman")
        XCTAssertEqual(result, mockResponse, "Function should decode correctly mock data")
        XCTAssertEqual(result.description.first?.title, "Spiderman: No Way Home", "Title should be the same")
    }
    
    func test_fetchMovies_throwsInvalidResponse_on404Error() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        do {
            _ = try await sut.fetchMovies(searchTerm: "TestMovie")
            XCTFail("We should have an error here, but it did not appear.")
        }
        catch let error as NetworkError {
            if case let .invalidResponse(statusCode) = error {
                XCTAssertEqual(statusCode, 404, "The status code should be 404.")
            } else {
                XCTFail("It thrown a different error: \(error)")
            }
        }
        catch {
            XCTFail("It threw an unexpected error: \(error)")
        }
    }
    
    func test_fetchMovies_throwsDecodingError_onMalformedData() async {
        let malformedJson = "{\"status\" : \"error\", \"message\" : \"No movies found.\"}".data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, malformedJson)
        }
        
        do {
            _ = try await sut.fetchMovies(searchTerm: "TestMovie")
            XCTFail("Should have thrown a decoding error, but did not.")
        } catch let error as NetworkError {
            if case .decodingError = error {
                XCTAssert(true, "Should throw a decoding error")
            } else {
                XCTFail("It threw a different error: \(error)")
            }
        }
        catch {
            XCTFail("It threw an unexpected error: \(error)")
        }
    }
}

