import Foundation
import Presentation
import Validation

class EmailValidatorSpy: EmailValidator {
    
    var isvalid = true
    var email: String?
    
    func isValid(email: String) -> Bool {
        self.email = email
        return isvalid
    }
    
    func simulateInvalidEmail(){
        self.isvalid = false
    }
    
}
