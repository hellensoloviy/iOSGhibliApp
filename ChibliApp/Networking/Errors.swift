//
//  Errors.swift
//  ChibliApp
//
//  Created by Olena Solovii on 01.02.2026.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    
    var customDescription: String? {
        switch self {
        case .decodingError(let error):
            return "Failed to decode with error: \n \(error.localizedDescription) \n"
        case .networkError(let error):
            return "Network error: \n \(error.localizedDescription) \n"
        case .invalidResponse:
            return "The response is invalid."
        case .invalidURL:
            return "The URL is invalid."
        default:
            return "Not defined error decription."
        }
    }

}
