//
//  ApiService.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 20.11.2025.
//

//https://imdb.iamidiotareyoutoo.com/search?q=Spiderman

import Foundation
import UIKit

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidResponse(statusCode: Int)
    case decodingError
    case networkError(Error)
}

 final class ApiService {
    static let shared = ApiService()
    
    private var baseUrlComponent: URLComponents = {
        var url = URLComponents()
        url.scheme = "https"
        url.host = "imdb.iamidiotareyoutoo.com"
        url.path = "/search"
        return url
    }()
    
   
    
    func fetchMovies(searchTerm: String) async throws -> MovieResponse {
        var component = baseUrlComponent
        component.queryItems = [
            .init(name: "q", value: searchTerm)
        ]
        guard let url = component.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: 0)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        let movieData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return movieData
    }
}
