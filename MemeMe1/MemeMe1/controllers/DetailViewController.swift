//
//  DetailViewController.swift
//  MemeMe1
//
//  Created by Sarah Alhabib on 25/10/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var meme:Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image=meme?.memedImage
    }
}
