//
//  SecondGraphsViewController.swift
//  
//
//  Created by Rishabh Thakkar on 1/4/18.
//  Copyright © 2018 ribsthak. All rights reserved.
//

import UIKit
import Charts

class PieGraphViewController: UIViewController {
	//Setup storyboard connections and class variables
	@IBOutlet weak var pieChart: PieChartView!
	var chartDictionary = [String: Double]()
    var loanAmount: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	override func viewWillAppear(_ animated: Bool) {
		updatePieGraph()
		print("piegraph Appear")
	}
	func updatePieGraph() {
		//Access keys of the dictionary, which are the expense categories
		let keys = Array(chartDictionary.keys)
		//create array of PieChartDataEntries
		var entries = [PieChartDataEntry]()
		
		//loop through each category, create data entry and added to list of data entries
		for i in 0..<chartDictionary.count {
			if(chartDictionary[keys[i]]! > 0) {
				let dataEntry1 = PieChartDataEntry(value: chartDictionary[keys[i]]!, label: keys[i])
				entries.append(dataEntry1) // here we add it to the data set
			}
		}
		
		// PieChartDataSet created from entries
        let set = PieChartDataSet( entries: entries.reversed(), label: "Total Amount")
		var colors: [UIColor] = []
		
		//set random colors for the pie chart sections
		for _ in 0..<keys.count {
			let red = Double(arc4random_uniform(256))
			let green = Double(arc4random_uniform(256))
			let blue = Double(arc4random_uniform(256))
			let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
			colors.append(color)
		}
        
		//Set the data and other descriptors for the PieChartView
		set.colors = colors
		let data = PieChartData(dataSet: set)
		pieChart.data = data
		pieChart.data?.setValueFormatter(YAxisValueFormatter())
		pieChart.chartDescription?.text = "Loan Amount" + "  " + String(format : "%.0f", floor(self.loanAmount))
		pieChart.noDataText = "No data available"
		pieChart.holeRadiusPercent = 0.2
		pieChart.transparentCircleColor = UIColor.clear
	}
}

class YAxisValueFormatter: NSObject, IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return numFormatter.string(from: NSNumber(floatLiteral: value))!
        
    }
    
    
    let numFormatter: NumberFormatter
    
    override init() {
        numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 2
        numFormatter.maximumFractionDigits = 2
        
        // if number is less than 1 add 0 before decimal
        numFormatter.minimumIntegerDigits = 1 // how many digits do want before decimal
        numFormatter.paddingPosition = .beforePrefix
        numFormatter.paddingCharacter = "0"
    }
    
    /// Called when a value from an axis is formatted before being drawn.
    ///
    /// For performance reasons, avoid excessive calculations and memory allocations inside this method.
    ///
    /// - returns: The customized label that is drawn on the axis.
    /// - parameter value:           the value that is currently being drawn
    /// - parameter axis:            the axis that the value belongs to
    ///
    
    
}
