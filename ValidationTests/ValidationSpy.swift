import Presentation

class ValidationSpy: Validation {
    var errorMessage: String?
    func validate(data: [String : Any]?) -> String? {
        return errorMessage
    }
    func simulateError(_ errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
