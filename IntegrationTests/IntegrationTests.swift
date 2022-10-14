import XCTest
import Domain
import Data
import Infra

final class IntegrationTests: XCTestCase {

    func test_add_account(){
        let url = URL(string: "http://192.168.1.8:3001/signup")!
        let httpPostClient = AlamofireAdapter()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClient)
        let addAccountModel = AddAccountModel(name: "any-name", email: "any-email@email.com", password: "any-password", password_confirmation: "any-password")
        
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure: XCTFail("Expect succcess got \(result) instead")
            case .success(let account):
                XCTAssertEqual(account.password, addAccountModel.password)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        
    }

}
