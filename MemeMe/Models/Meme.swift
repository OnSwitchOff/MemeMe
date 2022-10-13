//
//  Meme.swift
//  MemeMe
//
//  Created by MacBook Pro on 13.10.22.
//

import Foundation
import UIKit

class Meme {
    let topText: String!
    let bottomText: String!
    let originalImage: UIImage!
    let memedImage: UIImage!
    
    init(topText: String, bottomText: String, originalImage: UIImage!, memedImage: UIImage!){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}
