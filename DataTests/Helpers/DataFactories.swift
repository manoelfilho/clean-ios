import Foundation
import Domain

func makeEmptyData() -> Data{
    return Data()
}

func makeValidData() -> Data{
    return Data("{\"name\":\"Manoel\"}".utf8)
}

func makeInvalidData() -> Data{
    return Data("invalid_data".utf8)
}

func makeUrl() -> URL {
    return URL(string: "http://any-url.com.br")!
}

func makeError() -> Error{
    return NSError(domain: "any-error", code: 0)
}

func makeHttpResponse(statusCode: Int = 200) -> HTTPURLResponse? {
    return HTTPURLResponse(url: makeUrl(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func makeAccountModel() -> AccountModel {
    return AccountModel(id:"1", name: "any-name", email: "any-email@email.com", password: "any-password")
}

func makeAddAccountModel() -> AddAccountModel {
    return AddAccountModel(name: "any-name", email: "any-email@email.com", password: "any-password", passwordConfirmation: "any-password")
}
