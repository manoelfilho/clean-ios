import Foundation

public protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, Error>) -> Void)
}

public struct AddAccountModel: Model {
    public var name: String
    public var email: String
    public var password: String
    public var password_confirmation: String
    
    public init(name: String, email: String, password: String, password_confirmation: String){
        self.name = name
        self.email = email
        self.password = password
        self.password_confirmation = password_confirmation
    }
}
