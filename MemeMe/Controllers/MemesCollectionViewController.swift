//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by MacBook Pro on 13.03.23.
//

import Foundation
import UIKit

class MemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!

    var allMemes =  (UIApplication.shared.delegate as! AppDelegate).memes
    
    @IBOutlet var tmCollectionView: UICollectionView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - 2 * space) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.allMemes =  (UIApplication.shared.delegate as! AppDelegate).memes
        
        tmCollectionView.reloadData()
    }
    
    // MARK: Table View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.allMemes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        //cell.nameLabel.text = villain.name
        cell.MemeImageView?.image = meme.originalImage
        cell.TextLabel.text = "lab"

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.allMemes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

    
    @IBAction func CreateMeme(_ sender: Any) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}


class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var MemeImageView: UIImageView!
    @IBOutlet var TextLabel: UILabel!
}
