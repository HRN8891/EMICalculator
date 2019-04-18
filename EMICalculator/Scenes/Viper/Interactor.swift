//
//  Interactor.swift
//  EMICalculator


import UIKit

protocol InteractorInput {
    func doSomething(_ request: Request)
}

protocol InteractorOutput {
    func presentSomething(_ response: Response)
}

class Interactor: InteractorInput
{
    var output: InteractorOutput!
    var worker: CalculatorWorker!
    
    // MARK: Business logic
    
    func doSomething(_ request: Request)
    {
        // NOTE: Create some Worker to do the work
        worker = CalculatorWorker()
        let requestEmiCalculation = request.requestEmiCalculation
        let emi = worker.calculateEmi(Double(requestEmiCalculation.loanAmount), loanTenure: Double(requestEmiCalculation.loanTenure), interestRate: Double(requestEmiCalculation.interestRate))
        let totalPayment = worker.calculateTotalPayment(emi, loanTenure: requestEmiCalculation.loanTenure)
        let totalPayableInterest = worker.calculateTotalInterestPayable(totalPayment, loanAmount: Double(requestEmiCalculation.loanAmount))
        // NOTE: Pass the result to the Presenter
        
        
//        let emiCalculatorResponse = EmiCalculatorResponse.ResponseEmiCalculation(totalPayment : Double(totalPayment), totalPaymentInterest : totalPayableInterest, loanEmi : Double(emi))
//        let EmiCalculatorResponse = EmiCalculatorResponse(responseEmiCalculation : emiCalculatorResponse)
////
//        output.presentSomething(EmiCalculatorResponse)
        
        let response = Response.ResponseEmiCalculation(totalPayment : Double(totalPayment), totalPaymentInterest : totalPayableInterest, loanEmi : Double(emi))
        let emiCalculatorResponse = Response(responseEmiCalculation : response)
        output.presentSomething(emiCalculatorResponse)

    }
}
