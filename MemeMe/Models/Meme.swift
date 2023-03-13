//
//  Meme.swift
//  MemeMe
//
//  Created by MacBook Pro on 13.10.22.
//

import Foundation
import UIKit

struct Meme {
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

extension Meme {
    // Generate an array full of all of the villains in
    static var allMemes: [Meme] {
        let memeArray = [Meme]()
        return memeArray
    }
}
