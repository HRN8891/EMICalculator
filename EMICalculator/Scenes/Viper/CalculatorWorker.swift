//
//  CalculatorWorker.swift
//  EMICalculator


import UIKit

class CalculatorWorker {
    // MARK: Business Logic
    func calculateEmi(_ loanAmount : Double, loanTenure : Double, interestRate : Double) -> Double {
        let interestRateVal = interestRate / 1200
        let loanTenureVal = loanTenure * 12
        return loanAmount * interestRateVal / (1 - (pow(1/(1 + interestRateVal), loanTenureVal)))
    }
    
    func calculateTotalPayment(_ emi : Double, loanTenure : NSInteger) -> Double {
        let totalMonth = loanTenure * 12
        return emi * Double(totalMonth)
    }
    
    func calculateTotalInterestPayable(_ totalPayment : Double, loanAmount : Double) -> Double {
        return totalPayment - loanAmount
    }
}
