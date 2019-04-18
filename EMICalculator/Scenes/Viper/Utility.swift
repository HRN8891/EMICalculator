//
//  Utility.swift
//  EMICalculator



import UIKit

struct Request {
    struct RequestEmiCalculation {
        var loanAmount : Double
        var loanTenure : NSInteger
        var interestRate : Double
    }
    var requestEmiCalculation : RequestEmiCalculation
}

struct Response {
    struct ResponseEmiCalculation {
        var totalPayment : Double
        var totalPaymentInterest : Double
        var loanEmi : Double
    }
    var responseEmiCalculation : ResponseEmiCalculation
}

struct EMIViewModel
{
    struct DisplayEmiCalculation {
        var totalPayment : Double
        var totalPaymentInterest : Double
        var loanEmi : Double
    }
    var emiCalculation : DisplayEmiCalculation
}


extension EMICalculatorVC: EmiCalculatorPresenterOutput
{
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        router.passDataToNextScene(segue)
    }
}

extension Interactor: EmiCalculatorViewControllerOutput {
}

extension Presenter: InteractorOutput {
}

class Configurator {
    
    static let instance: Configurator = Configurator()
    class var shared: Configurator {
        struct Static {
            static var instance: Configurator?
            static var token: Int = 0
        }
        return instance
    }
    
    func configure(viewController: EMICalculatorVC) {
        let router = Router()
        router.viewController = viewController
        
        let presenter = Presenter()
        presenter.output = viewController
        
        let interactor = Interactor()
        interactor.output = presenter
        
        viewController.output = interactor
        viewController.router = router
    }
}
