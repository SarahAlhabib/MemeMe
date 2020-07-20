//
//  SentMemesCollectionViewController.swift
//  MemeMe1
//
//  Created by Sarah Alhabib on 25/10/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 1.5
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
       
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionViewCell", for: indexPath) as! memeCollectionViewCell
        cell.imageView.image=memes[indexPath.item].memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailController.meme=memes[indexPath.item]
        navigationController?.pushViewController(detailController, animated: true)
    }

    @IBAction func newMeme(_ sender: Any) {
        let createMemeController = storyboard?.instantiateViewController(identifier: "CreateMemeViewController") as! CreateMemeViewController
        present(createMemeController, animated: true, completion: nil)
        
    }
}
