//
//  NetworkError.swift
//  NetworkClient
//
//  Created by Germán Hernández del Rosario on 26/7/24.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode(statusCode: Int)
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}
