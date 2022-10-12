import Foundation
import Domain

func makeInvalidData() -> Data {
    return Data("invalid_data".utf8)
}

func makeUrl() -> URL {
    return URL(string: "http://any-url.com")!
}

func makeAccountModel() -> AccountModel {
    return AccountModel(id: "1", name: "any-name", email: "any-email@email.com", password: "any-password")
}
