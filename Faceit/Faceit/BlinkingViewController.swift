//
//  BlinkingViewController.swift
//  Faceit
//
//  Created by ChenshuoYue on 6/15/17.
//  Copyright © 2017 Machinarist. All rights reserved.
//

import UIKit

class BlinkingViewController: FaceViewController
{
	var blinking = false {
		didSet{
			blinkIfNeeded()
		}
	}
	
	private struct BlinkRate {
		static let closedDuration: TimeInterval = 0.4
		static let openDuration: TimeInterval = 2.5
		
	}
	
	
	
	
	private func blinkIfNeeded() {
		if blinking {
			faceView.eyesOpen = false
			Timer.scheduledTimer(withTimeInterval: BlinkRate.closedDuration, repeats: false) { [weak self] timer in
				self?.faceView.eyesOpen = true
				Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false){	[weak self] timer in self?.blinkIfNeeded()
				}
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		blinking = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
		blinking = false
	}

}
