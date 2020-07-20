//
//  SentMemesTableViewVC.swift
//  MemeMe1
//
//  Created by Sarah Alhabib on 25/10/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import UIKit

class SentMemesTableViewVC: UITableViewController {
    
   
    var memes: [Meme]! {
           let object = UIApplication.shared.delegate
           let appDelegate = object as! AppDelegate
           return appDelegate.memes
       }
       
    override func viewDidLoad() {
           super.viewDidLoad()
           
       }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell")!
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.image=memes[indexPath.row].memedImage
        cell.textLabel?.text=memes[indexPath.row].topText+" "+memes[indexPath.row].buttomText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailController.meme=memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
        
    }
    
    @IBAction func newMeme(_ sender: Any) {
        let createMemeController = storyboard?.instantiateViewController(identifier: "CreateMemeViewController") as! CreateMemeViewController
        present(createMemeController, animated: true, completion: nil)
    }
    
}
