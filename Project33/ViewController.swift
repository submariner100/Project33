//
//  ViewController.swift
//  Project33
//
//  Created by Macbook on 02/08/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "What's that Whistle?"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
		
  
	}
	
	func addWhistle() {
		
		let vc = RecordWhistleViewController()
		navigationController?.pushViewController(vc, animated: true)
		
	}
	
	
	
}

