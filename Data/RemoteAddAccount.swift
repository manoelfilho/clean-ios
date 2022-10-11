import Foundation
import Domain

class RemoteAddAccount: AddAccount{
    
    var url: URL
    var httpPostClient: HttpPostClient
    
    init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, Error>) -> Void) {
        let data = addAccountModel.toData()
        self.httpPostClient.post(to: self.url, with: data)
    }
    
}
