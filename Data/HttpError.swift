import Foundation

public enum HttpError: Error {
    case unauthorized
    case forbiden
    case badRequest
    case serverError
    case noConnectivity
}
