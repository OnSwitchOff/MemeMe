//
//  MemeDetails.swift
//  MemeMe
//
//  Created by MacBook Pro on 13.03.23.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
