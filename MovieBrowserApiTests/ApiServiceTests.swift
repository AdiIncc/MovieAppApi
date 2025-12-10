//
//  MovieBrowserApiTests.swift
//  MovieBrowserApiTests
//
//  Created by Adrian Inculet on 10.12.2025.
//

import Testing
import XCTest
@testable import Pods_MovieBrowserApi

let mockMovieJSON = """
{
    "query": "Inception",
    "results": [
        {
            "id": "tt1375666",
            "title": "Inception",
            "year": 2010,
            "image": "https://example.com/inception.jpg"
        },
        {
            "id": "tt1790736",
            "title": "Inception: The Cobol Job",
            "year": 2010,
            "image": "https://example.com/cobol.jpg"
        }
    ]
}
""".data(using: .utf8)!

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

// Mock URL Session
class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error { throw error }
        guard let data = data, let response = response else { fatalError("Mock not configured") }
            return (data, response)
        }
    }


struct ApiServiceTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}
