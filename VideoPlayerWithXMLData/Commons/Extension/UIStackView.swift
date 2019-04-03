//
//  UIStackView.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 4/3/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func setBackgroundColor(_ color: UIColor) {
        let backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = color
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backgroundView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
}
