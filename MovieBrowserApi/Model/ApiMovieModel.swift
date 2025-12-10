//
//  ApiModel.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 19.11.2025.
//

import Foundation

struct MovieResponse: Codable, Equatable {
    let ok: Bool
    let errorCode: Int
    let description: [MovieListItem]
    
    enum CodingKeys: String, CodingKey {
        case description, ok
        case errorCode = "error_code"
    }
}

struct MovieListItem: Codable, Equatable {
    let title: String
    let imdbID: String
    let year: Int
    let posterURL: String
    let rank: Int
    
    enum CodingKeys: String, CodingKey {
        case title = "#TITLE"
        case imdbID = "#IMDB_ID"
        case year = "#YEAR"
        case posterURL = "#IMG_POSTER"
        case rank = "#RANK"
    }
}
