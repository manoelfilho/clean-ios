import Foundation
import Domain

public class SignUpPresenter {
    
    private let addAccount: AddAccount
    private let loadingView: LoadingView
    private let alertView: AlertView
    private let validation: Validation
    
    public init(addAccount: AddAccount, loadingView: LoadingView, alertView: AlertView, validation: Validation){
        self.addAccount = addAccount
        self.loadingView = loadingView
        self.alertView = alertView
        self.validation = validation
    }
    
    public func signUp(viewModel: SignUpRequest){
        
        if let message = validation.validate(data: viewModel.toJson()) {
        
            alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        
        } else {
                        
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            
            addAccount.add(addAccountModel: viewModel.toAddAccountModel()) { [weak self] result in
            
                guard let self = self else { return }
                
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
                
                switch result {
                    
                    case .success:
                        self.alertView.showMessage(viewModel: AlertViewModel(title: "Sucesso", message: "Conta criada com sucesso."))
                    
                    case .failure(let error):
                        switch error {
                            case .unexpected:
                                self.alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
                            case .emailInUse:
                            self.alertView.showMessage(viewModel: AlertViewModel(title: "Erro", message: "Esse e-mail já está em uso."))
                        }
                    
                    
                }
                
            }
        }
        
    }
    

}
