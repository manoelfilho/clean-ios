import Foundation

public struct AccountModel {
    public var name: String
    public var email: String
    public var password: String
    
    init(name: String, email: String, password: String){
        self.name = name
        self.email = email
        self.password = password
    }
    
}
