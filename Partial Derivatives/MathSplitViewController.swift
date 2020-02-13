//
//  MathSplitViewController.swift
//  Partial Derivatives
//
//  Created by Jody Kocis on 3/3/19.
//  Copyright © 2019 Joseph Kocis. All rights reserved.
//

import Foundation
import UIKit

class MathSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    var isRunningInFullScreen: Bool? {
        didSet {
            changedFromFullScreen()
        }
    }
    
    
    override func viewDidLoad() {
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        
        isRunningInFullScreen = UIApplication.shared.delegate?.window??.frame.equalTo((UIApplication.shared.delegate?.window??.screen.bounds)!)
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        isRunningInFullScreen = size.equalTo((UIApplication.shared.delegate?.window??.screen.bounds.size)!)
        
    }
    
    func changedFromFullScreen() {
        if isRunningInFullScreen! {
            self.preferredDisplayMode = .allVisible
        } else if !isRunningInFullScreen! {
            self.preferredDisplayMode = .automatic
        }
    }
    
}
