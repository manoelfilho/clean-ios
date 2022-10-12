import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase{
    
    func test_add_should_call_http_post_client_with_correct_url(){
        let url = makeUrl()
        let (sut, httpPostClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel()) { _ in }
        XCTAssertEqual(httpPostClientSpy.urls, [url])
    }
    
    func test_add_should_call_http_post_client_with_correct_data(){
        let (sut, httpPostClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel, completion: { _ in })
        XCTAssertEqual(httpPostClientSpy.data, addAccountModel.toData())
    }
    
    /*
    
     Os três métodos funcionam para fazer testes automatizados do dado de retorno.
     Foram refatorados para algo mais simples, pois todos fazem o mesmo tipo de código
     
    func test_add_should_complete_with_error_if_client_completes_with_error(){
        let (sut, httpPostClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error and received \(result) instead")
            }
            exp.fulfill()
        }
        httpPostClientSpy.completeWithError(.noConectivity)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_account_if_client_completes_with_valid_data(){
        
        let (sut, httpPostClientSpy) = makeSut()
        let expectedAccountModel = makeAccountModel()
        let addAccountModel = makeAddAccountModel()
        
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure(let error): XCTFail("Expected account and received \(error) instead")
            case .success(let accoutModel): XCTAssertEqual(accoutModel, expectedAccountModel)
            }
            exp.fulfill()
        }
        httpPostClientSpy.completeWithSuccess(expectedAccountModel.toData()!)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data(){
        
        let (sut, httpPostClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success(let account): XCTFail("Expected error and received \(account) instead")
            }
            exp.fulfill()
        }
        httpPostClientSpy.completeWithSuccess(Data("invalid_date".utf8))
        wait(for: [exp], timeout: 1)
        
    }
    
    */
     
    func test_add_should_complete_with_error_if_client_completes_with_error(){
        let (sut, httpPostClientSpy) = makeSut()
        expec(sut, completeWith: .failure(.unexpected)) {
            httpPostClientSpy.completeWithError(.noConectivity)
        }
    }
    
    func test_add_should_complete_with_account_if_client_completes_with_valid_data(){
        let (sut, httpPostClientSpy) = makeSut()
        let expectedAccountModel = makeAccountModel()
        expec(sut, completeWith: .success(expectedAccountModel), when: {
            httpPostClientSpy.completeWithSuccess(expectedAccountModel.toData()!)
        })
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data(){
        let (sut, httpPostClientSpy) = makeSut()
        expec(sut, completeWith: .failure(.unexpected), when: {
            httpPostClientSpy.completeWithSuccess(makeInvalidData())
        })
    }
    
    func test_add_should_not_completes_if_sut_has_been_dealocated(){
        let httpPostClientSpy = HttpPostClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: makeUrl(), httpPostClient: httpPostClientSpy)
        var result: Result<AccountModel, DomainError>?
        sut?.add(addAccountModel: makeAddAccountModel(), completion: { receivedResult in
            result = receivedResult
        })
        sut = nil
        httpPostClientSpy.completeWithError(.noConectivity)
        XCTAssertNil(result)
    }
    
}

extension RemoteAddAccountTests {
    
    //Método inteligente para executar a ação do SUT Remote AddAccount e comparar um Result baseado em uma função e um Result que são passados como parâmetro
    func expec(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line){
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)):
                XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) and was received \(receivedResult)")
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
    
    func makeSut(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteAddAccount, httpPostClientSpy: HttpPostClientSpy){
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpPostClientSpy, file: file, line: line)
        
        return (sut, httpPostClientSpy)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any-name", email: "any-email@email.com", password: "any-password", password_confirmation: "any-password")
    }
    
}
