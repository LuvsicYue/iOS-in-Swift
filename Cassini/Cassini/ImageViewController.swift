//
//  ImageViewController.swift
//  Cassini
//
//  Created by ChenshuoYue on 5/27/17.
//  Copyright © 2017 Machinarist. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{
	var imageURL: URL? {
		didSet{
			image = nil
			if view.window != nil {
				fetchImage()
			}
		}
	}
	
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	private func fetchImage() {
		if let url = imageURL {
			// this next line of code can throw an error
			// and it also will block the UI entirely while access the network
			// we really should be doing it in a separate thread
			spinner.startAnimating()
			DispatchQueue.global(qos: .userInitiated).async { [weak self] in
				let urlContents = try? Data(contentsOf: url)
				if let imageDate = urlContents, url == self?.imageURL {
					DispatchQueue.main.async {
						self?.image = UIImage(data: imageDate)
					}
				}
			}
		}
	}
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if image == nil {
			fetchImage()
		}
	}
	
	
	
	
	@IBOutlet weak var scrollView: UIScrollView! {
		didSet {
			scrollView.delegate = self
			scrollView.minimumZoomScale = 0.03
			scrollView.maximumZoomScale = 1.5
			scrollView.contentSize = imageView.frame.size
			scrollView.addSubview(imageView)
		}
	}
	
	
	fileprivate var imageView = UIImageView()
	
	private var image: UIImage? {
		get {
			return imageView.image
		}
		set {
			imageView.image = newValue
			imageView.sizeToFit()
			scrollView?.contentSize = imageView.frame.size
			// in prepare, outlets not set
			spinner?.stopAnimating()
		}
	
	}


}

extension ImageViewController : UIScrollViewDelegate
{
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}
