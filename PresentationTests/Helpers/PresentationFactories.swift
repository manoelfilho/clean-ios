import Foundation
import Presentation

func makeSignUpViewModel(name: String? = "any-name", email: String? = "any-email@email.com", password: String? = "any-password", passwordConfirmation: String? = "any-password") -> SignUpRequest {
    return SignUpRequest(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
}
