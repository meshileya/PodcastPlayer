//
//  ChannelCell.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ChannelCell: UICollectionViewCell {
    
    var rssItem: RSSFeed? {
        didSet {
            let channel = rssItem?.channel
            titleLabel.text = channel?.title
            
            if let channelName = channel?.pubDate{
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
            }
            
            let podMinute = channel?.category
//            let subtitleText = "\(channel?.description) • !)"
            subtitleTextView.text = channel?.description
            
            if let title = channel?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
            
//
            if let thumbnailImageUrl = channel?.image?[0].url {
                let placeholder = "icon_default_avatar"
                let url = URL(string: thumbnailImageUrl )
                self.thumbnailImageView.kf.setImage(with: url, placeholder: UIImage(named: placeholder))
            }
            let episodesNumber = channel?.items?.count
            episodesLabel.text = "(\(episodesNumber!)) episodes"
            
            let airDate = channel?.pubDate
            airDateLabel.text = "Airdate: \(airDate!)"
        }
    }
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_default_avatar")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.frame.height - 100).isActive = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Not Available"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    let subtitleTextView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Not Available"
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    let subtitleTextView1: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Not Available"
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    let moreInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MORE INFO"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
//        label.font = UIFont(name: "Heiti TC", size: 15)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    let airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "AirDate"
        label.numberOfLines = 2
        label.font = UIFont(name: "Heiti TC", size: 10)
        label.textColor = .white
        return label
    }()
    
    let episodesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Episodes"
        label.font = UIFont(name: "Heiti TC", size: 10)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    lazy var infoDetailsView : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.backgroundColor = .black
        view.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        view.addSubview(titleLabel)
        view.addSubview(subtitleTextView)
        view.addSubview(moreInfoLabel)
        view.addSubview(airDateLabel)
        view.addSubview(episodesLabel)
        
        
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10))
        //left constraint
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 10))
        //right constraint
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -50))
        
        view.addConstraint(NSLayoutConstraint(item: moreInfoLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 10))
        //right constraint
        view.addConstraint(NSLayoutConstraint(item: moreInfoLabel, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -10))
        
        //top constraint
        view.addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        //left constraint
        view.addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 10))
        //right constraint
        view.addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -10))
        //height constraint
        view.addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
        
        view.addConstraint(NSLayoutConstraint(item: airDateLabel, attribute: .top, relatedBy: .equal, toItem: subtitleTextView, attribute: .bottom, multiplier: 1, constant: 10))
        //left constraint
        view.addConstraint(NSLayoutConstraint(item: airDateLabel, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 10))
        //right constraint
        view.addConstraint(NSLayoutConstraint(item: airDateLabel, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -50))
        
        view.addConstraint(NSLayoutConstraint(item: episodesLabel, attribute: .top, relatedBy: .equal, toItem: subtitleTextView, attribute: .bottom, multiplier: 1, constant: 10))
        //right constraint
        view.addConstraint(NSLayoutConstraint(item: episodesLabel, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -10))
        
        return view
    }()
    
   
    
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    lazy var allView : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 15
        view.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        view.addSubview(thumbnailImageView)
        view.addSubview(infoDetailsView)
        view.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 8))
        //left constraint
        view.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        //right constraint
        view.addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -0))
        
        view.addConstraint(NSLayoutConstraint(item: infoDetailsView, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 1))
        //left constraint
        view.addConstraint(NSLayoutConstraint(item: infoDetailsView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 10))
        //right constraint
        view.addConstraint(NSLayoutConstraint(item: infoDetailsView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -10))
        view.addConstraint(NSLayoutConstraint(item: infoDetailsView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -10))
        return view
        
    }()
    
    func setupViews() {
        addSubview(allView)
        allView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        allView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        allView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        allView.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        
        //top constraint
        
        
        //top constraint
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
//        self.contentView.layer.cornerRadius = 10
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        //        self.layer.shadowRadius = shadowBlur
        //        self.layer.shadowOpacity = 1
         self.contentView.layer.cornerRadius = 10
        infoDetailsView.layer.cornerRadius = 10
        infoDetailsView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
