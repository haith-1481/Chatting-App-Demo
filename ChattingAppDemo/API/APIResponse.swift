//
//  APIResponse.swift
//  ChattingAppDemo
//
//  Created by Sean on 24/08/2023.
//

import Foundation

enum APIError: Error {
	case network
	case unauthorized
	case expiredToken
	case badRequest(String?, String?)
	case notFound
	case other
	case requestExisted
}

extension APIError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .network:
			return "No internet connection"
		case .other:
			return "Undefined error"
		case .requestExisted:
			return "Bản ghi đã tồn tại"
		default:
			return self.localizedDescription
		}
	}
}

enum ErrorCodeDefined: Int {
	// Define later
	case ok = 9999
}

enum HttpStatusCode: Int, Decodable {
	case ok = 200
	case created = 201
	case accepted = 202
	case badRequest = 400
	case authenticationFailure = 401
	case forbidden = 403
	case resourceNotFound = 404
	case methodNotAllowed = 405
	case conflict = 409
	case preconditionFailed = 412
	case requestEntityTooLarge = 413
	case internalError = 500
	case notImplemented = 501
	case offlineMaintainace = 503
	case networkError
	case unknown
	case uploadFailed
	case requestExisted = 422
}

struct APIResponse<T: Decodable>: Decodable {
	var data: T?
}

struct MessageResponse: Decodable {
	var message: String?
}

struct APIErrorResult: Decodable {
	var errorCode: Int?
	var errorMessage: String?
	var info: String?
}

struct APIErrorResponse: Error, Decodable {
	var errorCode: HttpStatusCode = .unknown
	var errorMessage: String?
	
	enum CodingKeys: String, CodingKey {
		case errorCode = "error_code"
		case errorMessage = "error"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		if let errorCodeRawValue = try? container.decode(Int.self, forKey: .errorCode) {
			errorCode = HttpStatusCode(rawValue: errorCodeRawValue) ?? .unknown
		}
		errorMessage = try? container.decodeIfPresent(String.self, forKey: .errorMessage)
	}
}
