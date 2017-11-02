//
//  ViewController.swift
//  Calculator
//
//  Created by ChenshuoYue on 5/16/17.
//  Copyright © 2017 Machinarist. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	
	
	@IBOutlet weak var display: UILabel!
	
	var userIsInTheMiddleOfTyping = false
	var hasDot = false
	
	private func showSizeClasses() {
		if !userIsInTheMiddleOfTyping {
			display.textAlignment = .center
			display.text = "width " + traitCollection.horizontalSizeClass.description + " height"
							+ traitCollection.verticalSizeClass.description
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		showSizeClasses()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		coordinator.animate(alongsideTransition: { coordinator in
			self.showSizeClasses()
		}, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		brain.addUnaryOperation(named: "✅") { [unowned self] in
			self.display.textColor = UIColor.green
			return sqrt($0)
		}
		
	}
	@IBAction func touchDigit(_ sender: UIButton) {
		let digit = sender.currentTitle!
		if userIsInTheMiddleOfTyping {
			let textCurrentlyInDisplay = display.text!
			if digit == "."  {
				if !hasDot {
					display.text = textCurrentlyInDisplay + digit
					hasDot = true
				}
			} else {
				display.text = textCurrentlyInDisplay + digit
			}
		
			print("\(digit) was touched")
		} else {
			display.text = digit
			userIsInTheMiddleOfTyping = true
		}
		
	}
	
	var displayValue: Double {
		get {
			return Double(display.text!)!
		}
		set {
			display.text = String(newValue)
		}
	}
	
	private var brain = CalculatorBrain()
	
	@IBAction func performOperation(_ sender: UIButton) {
		if userIsInTheMiddleOfTyping {
			brain.setOperand(displayValue)
			userIsInTheMiddleOfTyping = false
			hasDot = false
		}
		
		if let mathematicalSymbol = sender.currentTitle {
			brain.performOperation(mathematicalSymbol)
			
		}
		if let result = brain.result {
			displayValue = result
		}
	}
	
}

extension UIUserInterfaceSizeClass: CustomStringConvertible {
	public var description: String {
		switch self {
		case .compact: return "Compact"
		case .regular: return "Regular"
		case .unspecified: return "??"
		}
	}
}
// startX: internal name
// from: External name
//	func drawHorizontalLine(from startX: Double, to endX: Double, using color: UIColor) {
//
//	}
