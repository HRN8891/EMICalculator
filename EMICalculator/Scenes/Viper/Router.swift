//
//  Router.swift
//  EMICalculator


import UIKit

protocol RouterInput {
    func navigateToSomewhere()
}

class Router {
    weak var viewController: EMICalculatorVC!
    
    // MARK: Navigation
    
   
    // MARK: Communication
    
    func passDataToNextScene(_ segue: UIStoryboardSegue)
    {
        // NOTE: Teach the router which scenes it can communicate with
        
        if segue.identifier == "ShowSomewhereScene" {
            passDataToSomewhereScene(segue)
        }
    }
    
    func passDataToSomewhereScene(_ segue: UIStoryboardSegue)
    {
        // NOTE: Teach the router how to pass data to the next scene
        
        // let someWhereViewController = segue.destinationViewController as! SomeWhereViewController
        // someWhereViewController.output.name = viewController.output.name
    }
}
