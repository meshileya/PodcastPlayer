//
//  ProtocolExtension.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/31/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import UIKit

extension UIViewDialogProtocol where Self: UIView {
    
    func show (_ rect: CGRect? = nil) {
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(self)
            if rect == nil {
                self.frame = keyWindow.frame
            }
            else {
                self.frame = rect!
            }
            self.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.alpha = 1
                
            }, completion: nil)
        }
    }
    
    func dismiss (_ rect: CGRect? = nil) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if let window = UIApplication.shared.keyWindow {
                if let rect = rect {
                    self.frame = rect
                }
                else {
                    self.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
                }
            }
            
        }) {
            (completed: Bool) in
            self.removeFromSuperview()
        }
        
    }
    
}

