//
//  String.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/31/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
extension String{
    func removeWhitSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
