//
//  PodCastPlauerExtension.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import UIKit

extension PlayerDetailsView {
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
       if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self.miniPlayerView.isHidden = true
                self.maximizedStackView.isHidden = false
            } else {
                self.miniPlayerView.isHidden = false
                self.maximizedStackView.isHidden = true
            }
        })
    }
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximizedStackView.transform = .identity
                
                if translation.y > 50 {
                    self.miniPlayerView.isHidden = false
                    self.maximizedStackView.isHidden = true
                }else{
                    self.miniPlayerView.isHidden = true
                    self.maximizedStackView.isHidden = false
                }
                
            })
        }
    }
    
}

