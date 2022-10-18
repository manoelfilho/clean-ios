import XCTest
import Presentation
import Validation

class ValidationCompositeTests: XCTestCase {
    
    func test_validate_should_return_error_if_validation_fails(){
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        validationSpy.simulateError("Erro 1")
        let errorMessage = sut.validate(data: ["name": "Manoel"])
        XCTAssertEqual(errorMessage, "Erro 1")
    }
    
    func test_validate_should_return_correct_error_message(){
        let validationSpy1 = ValidationSpy()
        let validationSpy2 = ValidationSpy()
        let sut = makeSut(validations: [validationSpy1, validationSpy2])
        validationSpy2.simulateError("Erro 2")
        let errorMessage = sut.validate(data: ["name": "Manoel"])
        XCTAssertEqual(errorMessage, "Erro 2")
    }
    
    func test_validate_should_return_nil_if_validation_succeds(){
        let sut = makeSut(validations: [ValidationSpy(), ValidationSpy()])
        let errorMessage = sut.validate(data: ["name": "Manoel"])
        XCTAssertNil(errorMessage)
    }
    
}

extension ValidationCompositeTests {
    func makeSut(validations: [Validation], file: StaticString = #filePath, line: UInt = #line) -> ValidationComposite {
        let sut = ValidationComposite(validations: validations)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}

