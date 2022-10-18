import XCTest
import Presentation
import Validation

class RequiredFieldsValidationTests: XCTestCase {
    
    func test_should_return_erros_if_field_is_not_provided(){
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")
        let errorMessage = sut.validate(data: ["name": "Rodrigo"])
        XCTAssertEqual(errorMessage, "O campo Email é obrigatório")
    }
    
    func test_should_return_erros_with_correct_fieldLabel(){
        let sut = makeSut(fieldName: "age", fieldLabel: "Idade")
        let errorMessage = sut.validate(data: ["name": "Rodrigo"])
        XCTAssertEqual(errorMessage, "O campo Idade é obrigatório")
    }
    
    func test_should_return_nil_if_field_is_provided(){
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")
        let errorMessage = sut.validate(data: ["email": "email@emai.com"])
        XCTAssertNil(errorMessage)
    }
    
    func test_should_return_nil_if_noda_data_is_provided(){
        let sut = makeSut(fieldName: "email", fieldLabel: "Email")
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "O campo Email é obrigatório")
    }
}


extension RequiredFieldsValidationTests {
    func makeSut(fieldName: String, fieldLabel: String, file: StaticString = #filePath, line: UInt = #line) -> Validation {
        let sut = RequiredFieldValidation(fieldName: fieldName, fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
