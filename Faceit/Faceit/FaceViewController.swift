//
//  ViewController.swift
//  Faceit
//
//  Created by ChenshuoYue on 5/21/17.
//  Copyright © 2017 Machinarist. All rights reserved.
//

import UIKit

class FaceViewController: VCLLoggingViewController
{

	@IBOutlet weak var faceView: FaceView! {
		// work only once when hooked up by iOS
		didSet {
			let handler = #selector(FaceView.changeScale(byReactingTo:))
			let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
			faceView.addGestureRecognizer(pinchRecognizer)
//			let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
//			tapRecognizer.numberOfTapsRequired = 1
//			faceView.addGestureRecognizer(tapRecognizer)
			let swipeUpRecoginzer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
			swipeUpRecoginzer.direction = .up
			faceView.addGestureRecognizer(swipeUpRecoginzer)
			let swipeDownRecoginzer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappines))
			swipeDownRecoginzer.direction = .down
			faceView.addGestureRecognizer(swipeDownRecoginzer)
			updateUI()
		}
	}
	
	private struct HeadShake {
		static let angle = CGFloat.pi / 6
		static let segmentDuration: TimeInterval = 0.5
	}
	
	private func rotateFace(by angle: CGFloat) {
		faceView.transform = faceView.transform.rotated(by: angle)
	}
	
	private func shakeHead() {
		UIView.animate(
			withDuration: HeadShake.segmentDuration,
			animations: { self.rotateFace(by: HeadShake.angle) },
			completion: { finished in
				if finished {
					UIView.animate(
						withDuration: HeadShake.segmentDuration,
						animations: { self.rotateFace(by: -HeadShake.angle * 2)},
						completion: { finished in
							if finished {
								UIView.animate(
									withDuration: HeadShake.segmentDuration,
									animations: { self.rotateFace(by: HeadShake.angle)}
								)
							}
						}
					)
				}
				
			}
		)
	}
	
	
	
	@IBAction func shakeHead(_ sender: UITapGestureRecognizer) {
		shakeHead()
	}
	
	
	
	func increaseHappiness() {
		expression = expression.happier
	}
	
	func decreaseHappines() {
		expression = expression.sadder
	}
	
	
	func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
		if tapRecognizer.state == .ended {
			let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
			expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
		}
	}
	
	var expression = FacialExpression(eyes: .open, mouth: .neutral) {
		didSet {
			updateUI()
		}
		
	}
	
	private func updateUI()
	{
		
		switch expression.eyes {
		case .open:
			faceView?.eyesOpen = true
		case .closed:
			faceView?.eyesOpen = false
		case .squinting:
			faceView?.eyesOpen = false
		}
		
		faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
	}
	
	private let mouthCurvatures = [FacialExpression.Mouth.grin:0.5, .frown:-1.0, .smile:1.0,
	                               .neutral:0.0, .smirk: -0.5]
	

}

