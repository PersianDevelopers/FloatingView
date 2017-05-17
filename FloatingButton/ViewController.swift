//
//  ViewController.swift
//  FloatingButton
//
//  Created by Ali Pourhadi on 2017-05-07.
//  Copyright © 2017 Ali Pourhadi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var floatingButton : FloatingView = {
        let normalButton:UIButton = UIButton(type: UIButtonType.system)
        normalButton.backgroundColor = .red
        normalButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        normalButton.layer.cornerRadius = 50
        normalButton.addTarget(self, action: #selector(ViewController.printer), for: .touchUpInside)
        var floatingView = FloatingView(with: normalButton)
        floatingView.delegate = self
        return floatingView
    }()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func viewDidAppear(_ animated: Bool) {
        floatingButton.show()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    func printer() {
        print("Button Called")
    }
    
    @IBAction func show(_ sender: Any) {
        self.floatingButton.show()
    }
    
    @IBAction func hide(_ sender: Any) {
        self.floatingButton.hide()
    }
    
}

extension ViewController:FloatingViewDelegate {
    
    func viewDraggingDidBegin(view: UIView, in window: UIWindow?) {
        UIView.animate(withDuration: 0.4) {
            view.alpha = 0.8
        }
    }
    
    func viewDraggingDidEnd(view: UIView, in window: UIWindow?) {
		(view as? UIButton)?.cancelTracking(with: nil)
        UIView.animate(withDuration: 0.4) {
            view.alpha = 1.0
        }
    }
    
}
