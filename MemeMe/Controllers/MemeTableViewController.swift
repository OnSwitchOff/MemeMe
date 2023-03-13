//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by MacBook Pro on 13.03.23.
//
import UIKit
import Foundation

class MemeTableViewController: UITableViewController {
    
    var allMemes = (UIApplication.shared.delegate as! AppDelegate).memes
    
    @IBOutlet var tabView: UITableView!
    
    @IBAction func CreateMeme(_ sender: Any) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.allMemes =  (UIApplication.shared.delegate as! AppDelegate).memes
        
        tabView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.allMemes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.allMemes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
