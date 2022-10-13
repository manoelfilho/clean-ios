import XCTest
import Alamofire
import Mocker

/*
 
    Os teste que correspondem as respostas do Alamofire devem responder as seguintes situacoes
    considerando: data | response | error
    
    válidos:
    
    OK  OK  X
    X   X   OK -> ✅
 
    inválidos:
    
    OK  OK  OK
    OK  X   OK
    OK  X   X
    X   OK  OK
    X   OK  X
    X   X   X
 
 */

final class AlamofireAdapterTests: XCTestCase {
    
    func test_post_should_make_request_with_valid_url_and_method(){
        let url = makeUrl()
        testRequestFor(url: url, data: makeValidData()){ request in
            XCTAssertEqual(url, request.url) // verifica se a URL é igual no AlamofireAdapter e na Session
            XCTAssertEqual("POST", request.httpMethod) // verifica se o tipo de requisicao é do tipo post
            XCTAssertNotNil(request.httpBodyStream) // verifica se o body da requisicao nao esta vazio
        }
    }
    
    func test_post_should_make_request_with_no_data(){
        testRequestFor(url: makeUrl(), data: makeInvalidData()){ request in
            XCTAssertNil(request.httpBodyStream) // verifica se o body da requisicao nao esta vazio
        }
    }
    
    func test_post_should_make_complete_with_error_when_request_completes_with_error(){
        expectResultFor(.failure(.noConnectivity), when: (data: nil, response: nil, error: makeError()))
    }
    
    func test_post_should_complete_with_error_on_all_invalid_cases(){
        expectResultFor(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 200), error: makeError()))
        expectResultFor(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: makeError()))
        expectResultFor(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: nil))
        expectResultFor(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: nil))
        expectResultFor(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: nil))
        expectResultFor(.failure(.noConnectivity), when: (data: nil, response: nil, error: nil))
    }
    
    
    func test_post_should_make_complete_with_no_data_when_request_completes_with_204(){
        expectResultFor(.success(nil), when: (data: nil, response: makeHttpResponse(statusCode: 204), error: nil))
        expectResultFor(.success(nil), when: (data: makeEmptyData(), response: makeHttpResponse(statusCode: 204), error: nil))
        expectResultFor(.success(nil), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 204), error: nil))
    }
    
    func test_post_should_make_complete_with_data_when_request_completes_with_200(){
        expectResultFor(.success(makeValidData()), when: (data: makeValidData(), response: makeHttpResponse(), error: nil))
    }
    
    func test_post_should_make_complete_with_error_when_request_completes_with_non_200(){
        expectResultFor(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 400), error: nil))
        expectResultFor(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 500), error: nil))
        
        expectResultFor(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 499), error: nil))
        expectResultFor(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 599), error: nil))
        
        expectResultFor(.failure(.unauthorized), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 401), error: nil))
        expectResultFor(.failure(.forbiden), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 403), error: nil))
        expectResultFor(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 300), error: nil))
        expectResultFor(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 100), error: nil))
    }

    /*  Exemplo de teste com o TestURLProtocolStub
     
        func test_post_should_make_request_with_valid_url_and_method(){
            
            let url = makeUrl()
            TestURLProtocolStub.loadingHandler = { request in
                XCTAssertEqual(url, request.url)
                return (HTTPURLResponse(), makeValidData(), nil)
            }
            
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [TestURLProtocolStub.self]
            let session = Session(configuration: configuration)
            let sut = AlamofireAdapter(session: session)
            
            let exp = XCTestExpectation(description: "wait")
            sut.post(to: url, with: makeInvalidData()) { _ in exp.fulfill() }
            wait(for: [exp], timeout: 1)
            
        }
    */
    
}


extension AlamofireAdapterTests {
    
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func testRequestFor(url: URL, data: Data?, action: @escaping (URLRequest) -> Void){
        let sut = makeSut()
        let exp = expectation(description: "waiting")
        sut.post(to: url, with: data){ _ in exp.fulfill() }
        var request: URLRequest?
        UrlProtocolStub.observeRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }
    
    func expectResultFor (_ expectedResult: Result<Data?, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #filePath, line: UInt = #line){
        let sut = makeSut()
        UrlProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting")
        sut.post(to: makeUrl(), with: makeValidData()){ receivedResult in
            switch (expectedResult, receivedResult) {
                case (.failure(let expectedError), .failure(let receivedError)) : XCTAssertEqual(expectedError, receivedError, file: file, line: line)
                case (.success(let expectedData), .success(let receiveddata)) : XCTAssertEqual(expectedData, receiveddata, file: file, line: line)
                default: XCTFail("Expected \(expectedResult) got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
}
