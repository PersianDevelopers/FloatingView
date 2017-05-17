//
//  FloatingView.swift
//  FloatingView
//
//  Created by Ali Pourhadi on 2017-05-07.
//  Copyright © 2017 Ali Pourhadi. All rights reserved.
//

import Foundation
import UIKit

public protocol FloatingViewDelegate {
    func viewDraggingDidBegin(view:UIView, in window:UIWindow?)
    func viewDraggingDidEnd(view:UIView, in window:UIWindow?)
}

class FloatingWindow : UIWindow {
    public var topView : UIView = UIView()
    lazy var pointInsideCalled : Bool = true
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            self.pointInsideCalled = true
            return topView
        }
        if pointInsideCalled {
            self.pointInsideCalled = false
            return topView
        }
        return nil
    }
}

public class FloatingView {
	
	private var floatingWindow:FloatingWindow?
	private var appWindow:UIWindow?
    private var floatingView:UIView!
	
	/**
		is floating view showing
	*/
    public var isShowing = false
	
	/**
		Delegate reutrn events of your floating view.
	*/
    public var delegate:FloatingViewDelegate?
	
	/**
		Initilization of FloatingView
	
		- Parameter view:   A normal view that turns to floating view.
		- Parameter layer: The layer of Z that the View will be presented, by default it is 1. in case of have more windows change it.
	
	*/
	public init(with view:UIView , layer:CGFloat = 1) {
        
        self.floatingView = view
		self.appWindow = UIApplication.shared.keyWindow
		self.floatingWindow = FloatingWindow(frame: view.frame)
        self.floatingWindow?.topView = view
        self.floatingWindow?.rootViewController?.view = view
		self.floatingWindow?.windowLevel = layer
		self.floatingWindow?.makeKeyAndVisible()
        
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture(panGesture:)))
        panGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(panGesture)
        
	}

	/**
	Showing floating view
	*/
	public func show() {
        if self.isShowing { return }
		self.floatingWindow?.addSubview(self.floatingView)
        self.isShowing = true
		floatingWindow?.isHidden = false
	}
	
	/**
	Hidding floating view
	*/
	public func hide() {
        self.isShowing = false
		floatingWindow?.isHidden = true
	}
	
    @objc private func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began {
            self.delegate?.viewDraggingDidBegin(view: self.floatingView, in: self.floatingWindow)
        }
        
        if panGesture.state == .ended {
            self.delegate?.viewDraggingDidEnd(view: self.floatingView, in: self.floatingWindow)
        }
        
        if panGesture.state == .changed {
            let translation = panGesture.location(in: self.floatingView)
            self.viewDidMove(to: translation)
        }
    }
	
	// Handleing movement of view
	private func viewDidMove(to location:CGPoint) {
		UIView.animate(withDuration: 0.1, delay: 0.0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            let point = (self.floatingWindow?.convert(location, to: self.appWindow))!
			switch UIDevice.current.orientation {
				case .portrait :
					self.floatingWindow?.center = point
			case .landscapeLeft :
                self.floatingWindow?.center = CGPoint(x: (self.appWindow?.frame.size.height)! - point.y, y: point.x)

			case .landscapeRight :
                self.floatingWindow?.center = CGPoint(x: point.y, y: (self.appWindow?.frame.size.width)! - point.x)
			default :
				print("Floating View Does not Handler This Situation")
			}
		})
	}
}
