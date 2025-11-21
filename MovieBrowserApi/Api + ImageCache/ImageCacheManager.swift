//
//  ImageCacheManager.swift
//  MovieBrowserApi
//
//  Created by Adrian Inculet on 20.11.2025.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(from urlString: String) async throws -> UIImage {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        let (data,_) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.decodingError
        }
        imageCache.setObject(image, forKey: urlString as NSString)
        return image
    }
}
