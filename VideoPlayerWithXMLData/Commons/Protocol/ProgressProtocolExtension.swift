//
//  ProgressProtocolExtension.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

protocol ControllerDelegate {
    func showProgress(_ text: String)
    func hideProgress()
}

extension ControllerDelegate where Self:UIViewController {
    
    func showProgress (_ text: String = "Please wait...") {
        let coverView = UIView(frame: view.frame)
        coverView.tag = 90101
        coverView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        self.view.addSubview(coverView)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        
        let activityIndicatorView : NVActivityIndicatorView = NVActivityIndicatorView(frame: view.frame, type: .ballClipRotate)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.tag = 1
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicatorView.color = .blue
        coverView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        activityIndicatorView.centerXAnchor.constraint(equalTo: coverView.centerXAnchor).isActive = true;
        activityIndicatorView.centerYAnchor.constraint(equalTo: coverView.centerYAnchor).isActive = true;
        coverView.addSubview(label)
        _ = label.anchorLoader(activityIndicatorView.bottomAnchor, left: coverView.leftAnchor, bottom: nil, right: coverView.rightAnchor, topConstant: 5, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(coverView)
            coverView.frame = keyWindow.frame
            coverView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                coverView.alpha = 1
                
            }, completion: nil)
        }
    }
    
    func hideProgress() {
        if let keyWindow = UIApplication.shared.keyWindow {
            if let coverView = keyWindow.viewWithTag(90101) {
                let activityIndicatorView = coverView.viewWithTag(1) as? NVActivityIndicatorView
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    coverView.alpha = 0
                }) { (result) in
                    activityIndicatorView?.stopAnimating()
                    coverView.removeFromSuperview()
                }
            }
        }
    }
}
