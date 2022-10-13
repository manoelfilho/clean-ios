import Foundation
import Domain

class RemoteAddAccount: AddAccount{
    
    var url: URL
    var httpPostClient: HttpPostClient
    
    init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
        let data = addAccountModel.toData()
        self.httpPostClient.post(to: self.url, with: data) { [weak self] result in
            //usado para provar a possibilidade de um Memory leak
            //se a instancia de RemoteAddAccount for usada dentro da closure do HttpPost pode ocorrer
            //da instancia nunca ser liberada da memória
            //var x = self.url
            //----------------------------------------------------
            guard self != nil else { return }
            switch result {
            case .success(let data):
                if let model: AccountModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            case.failure:
                completion(.failure(.unexpected))
            }
        }
    }
    
}
