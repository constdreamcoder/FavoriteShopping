//
//  ShoppingURLSesssionError.swift
//  SaSACRecapAssignment
//
//  Created by SUCHAN CHANG on 2/5/24.
//

import Foundation

enum ShoppingURLSesssionError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
    case invalidURL
    case unknownError
}
