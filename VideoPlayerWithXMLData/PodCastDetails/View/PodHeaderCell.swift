//
//  PodHeaderCell.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import UIKit

class PodHeaderCell: UICollectionReusableView {
    
    var video: Channel? {
        didSet {
            if let profileImageUrl = video?.image?[0].url{
                let placeholder = "icon_default_avatar"
                let url = URL(string: profileImageUrl )
                self.imageView.kf.setImage(with: url, placeholder: UIImage(named: placeholder))
            }
        }
    }
    
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_default_avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.frame.height - 70).isActive = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        
        addSubview(imageView)
        imageView.fillSuperview()
        setupVisualEffectBlur()
    }
    
    var animator: UIViewPropertyAnimator!
    
    fileprivate func setupVisualEffectBlur() {
        animator = UIViewPropertyAnimator(duration: 2.0, curve: .linear, animations: { [weak self] in
            let blurEffect = UIBlurEffect(style: .regular)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            
            self?.addSubview(visualEffectView)
            visualEffectView.fillSuperview()
        })
        
//        self.animator?.startAnimation()
//        self.animator?.pauseAnimation()
//        self.animator?.fractionComplete = CGFloat(0.1)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.animator?.pauseAnimation()
//            self.animator?.stopAnimation(true)
//            self.animator?.finishAnimation(at: .current)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
