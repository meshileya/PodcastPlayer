//
//  PodDetailsCell.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class PodDetailsCell: UICollectionViewCell {
    
    var video: Item? {
        didSet {
           let podTitle = video?.title
            
            titleLabel.text = podTitle
            
        }
    }
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_play_pod")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return imageView
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.sizeToFit()
        return label
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 8))
        //left constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10))
        //right constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -80))
        
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 8))
        //right constraint
        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10))
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
