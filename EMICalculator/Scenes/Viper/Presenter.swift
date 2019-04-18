//
//  Presenter.swift
//  EMICalculator


import UIKit

protocol EmiCalculatorPresenterInput {
    func presentSomething(_ response: Response)
}

protocol EmiCalculatorPresenterOutput: class {
    func displaySomething(_ viewModel: EMIViewModel)
}

class Presenter: EmiCalculatorPresenterInput {
    weak var output: EmiCalculatorPresenterOutput!
    
    // MARK: Presentation logic
    
    func presentSomething(_ response: Response)
    {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        
        let viewModel = EMIViewModel.DisplayEmiCalculation(totalPayment : Double(response.responseEmiCalculation.totalPayment), totalPaymentInterest: Double(response.responseEmiCalculation.totalPaymentInterest), loanEmi: Double(response.responseEmiCalculation.loanEmi))
        
        let EMIModel = EMIViewModel(emiCalculation : viewModel)
        output.displaySomething(EMIModel)
    }
}
