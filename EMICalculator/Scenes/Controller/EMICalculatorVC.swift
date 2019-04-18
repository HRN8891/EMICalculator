//
//  EMICalculatorVC.swift
//  EMICalculator


import UIKit
import RangeSeekSlider

protocol EmiCalculatorViewControllerInput {
    func displaySomething(_ viewModel: EMIViewModel)
}

protocol EmiCalculatorViewControllerOutput {
    func doSomething(_ request: Request)
}

class EMICalculatorVC: UIViewController, EmiCalculatorViewControllerInput, UITextFieldDelegate {
    var output: EmiCalculatorViewControllerOutput!
    var router: Router!
    var chartDictionary = [String: Double]()

    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalInterestPayableLabel: UILabel!
    @IBOutlet var totalPaymentInterestPlusPrincipalLabel: UILabel!
    @IBOutlet var loanEmiLabel: UILabel!
    
    @IBOutlet var loanAmountTextField: UITextField!

    var loanTenureVal: Int = 0;
    var interestRateVal: Double = 0;
    var amountVal: Double = 0;
    @IBOutlet fileprivate weak var loanRangeSlider: RangeSeekSlider!
    @IBOutlet fileprivate weak var interestRateRangeSlider: RangeSeekSlider!

    // MARK: Object lifecycle
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loanRangeSlider.delegate = self
        interestRateRangeSlider.delegate = self

        self.title = "Calculate EMI"
        Configurator.shared.configure(viewController: self)
        
        chartDictionary ["Total Amount Payable"] = 0.0
        chartDictionary ["Interest Payable"] = 0.0

    }
    
    @IBAction func chartButton(_ sender: AnyObject) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PieGraphViewController") as? PieGraphViewController
        vc?.chartDictionary = chartDictionary
        vc?.loanAmount = self.amountVal
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    // MARK: Event handling
    
    func calculateEmiAction(_ amount : String) {
        // NOTE: Ask the Interactor to do some work
        if amount == "" || amount.count == 0 {
            return
        }
        let loanAmountVal = Double(amount)
        
        let requestEmiCalculationVal = Request.RequestEmiCalculation(loanAmount : loanAmountVal!, loanTenure: self.loanTenureVal, interestRate: self.interestRateVal);
        let request = Request(requestEmiCalculation : requestEmiCalculationVal)
        output.doSomething(request)
    }
    
    // MARK: Display logic
    
    func displaySomething(_ viewModel: EMIViewModel)
    {
        // NOTE: Display the result from the Presenter
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        
        self.totalPaymentInterestPlusPrincipalLabel.text = formatter.string(from: NSNumber(value: viewModel.emiCalculation.totalPayment.isNaN ? 0 : viewModel.emiCalculation.totalPayment))
        self.totalInterestPayableLabel.text = formatter.string(from: NSNumber(value: viewModel.emiCalculation.totalPaymentInterest.isNaN ? 0 : viewModel.emiCalculation.totalPaymentInterest))
        self.loanEmiLabel.text = formatter.string(from: NSNumber(value: viewModel.emiCalculation.loanEmi.isNaN ? 0 : viewModel.emiCalculation.loanEmi))
        
        chartDictionary ["Total Amount Payable"] = viewModel.emiCalculation.totalPayment
        chartDictionary ["Interest Payable"] = viewModel.emiCalculation.totalPaymentInterest
    }
    
    func returnCellForIndexPath(_ indexPath : IndexPath) -> UITableViewCell! {
        return self.tableView.cellForRow(at: indexPath)! as UITableViewCell
    }
    
    func returnAmountField() -> UITextField {
        return self.returnCellForIndexPath(IndexPath.init(row: 0, section: 0)).viewWithTag(111) as! UITextField
    }
    
    func returnLoanTenureField() -> UITextField {
        return self.returnCellForIndexPath(IndexPath.init(row: 1, section: 0)).viewWithTag(221) as! UITextField
    }
    
    func returnLoanTenureSlider() -> UISlider {
        return self.returnCellForIndexPath(IndexPath.init(row: 1, section: 0)).viewWithTag(222) as! UISlider
    }
    
    func returnInterestRateField() -> UITextField {
        return self.returnCellForIndexPath(IndexPath.init(row: 2, section: 0)).viewWithTag(331) as! UITextField
    }
    
    func returnInterestRateSlider() -> UISlider {
        return self.returnCellForIndexPath(IndexPath.init(row: 2, section: 0)).viewWithTag(332) as! UISlider
    }
    
    
    func applyRedBorderOnAmount() {
        self.loanAmountTextField.layer.borderColor = UIColor.red.cgColor
        self.loanAmountTextField.layer.borderWidth = 1;
        self.loanAmountTextField.layer.cornerRadius = 5;
    }
    
    func clearRedBorderOnAmount() {
        self.loanAmountTextField.layer.borderColor = UIColor.clear.cgColor
        self.loanAmountTextField.layer.borderWidth = 0;
        self.loanAmountTextField.layer.cornerRadius = 0;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let filtered = string.components(separatedBy: CharacterSet(charactersIn:"0123456789").inverted).joined(separator: "")
        if (string == filtered) {
            var txtAfterUpdate: NSString = textField.text! as NSString
            txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
            
            if (textField.tag == 331) { //Interest Rate Text Field
                self.interestRateVal = txtAfterUpdate.doubleValue
                calculateEmiAction(String(format : "%.0f", floor(self.amountVal)))
            } else { //Amount Text Field
                self.clearRedBorderOnAmount();
                self.amountVal = txtAfterUpdate.doubleValue
                calculateEmiAction(String(format : "%.0f", floor(self.amountVal)))
            }
            return true
        } else {
            return false
        }
    }
}


extension EMICalculatorVC: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === loanRangeSlider {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            self.loanTenureVal = Int(floor(minValue))
        }
        
        if slider === interestRateRangeSlider {
            self.interestRateVal = Double(floor(minValue))
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        }
        
        calculateEmiAction(self.loanAmountTextField.text!)
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
