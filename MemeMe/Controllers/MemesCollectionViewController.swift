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
        tabBarController?.tabBar.isHidden = false
        allMemes =  (UIApplication.shared.delegate as! AppDelegate).memes
        
        tmCollectionView.reloadData()
    }
    
    // MARK: Table View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.allMemes[(indexPath as NSIndexPath).row]
        
        cell.MemeImageView?.image = meme.originalImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = allMemes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailController, animated: true)
        
    }

    
    @IBAction func CreateMeme(_ sender: Any) {
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        navigationController!.pushViewController(detailController, animated: true)
    }
}


class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var MemeImageView: UIImageView!
    @IBOutlet var TextLabel: UILabel!
}
