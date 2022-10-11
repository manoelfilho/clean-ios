import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase{
    
    func test_add_should_call_http_post_client_with_correct_url(){
        let url = URL(string: "http://any-url.com")!
        let (sut, httpPostClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel()) { _ in }
        XCTAssertEqual(httpPostClientSpy.url, url)
    }
    
    func test_add_should_call_http_post_client_with_correct_data(){
        let (sut, httpPostClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel, completion: { _ in })
        XCTAssertEqual(httpPostClientSpy.data, addAccountModel.toData())
    }
    
}

extension RemoteAddAccountTests {
    
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpPostClientSpy: HttpPostClientSpy){
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        return (sut, httpPostClientSpy)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any-name", email: "any-email@email.com", password: "any-password", password_confirmation: "any-password")
    }
    
    class HttpPostClientSpy: HttpPostClient {
        var url: URL?
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
    
}
