//
//  GifFullScreenViewController.swift
//  GifySampleProject
//
//  Created by user on 17/02/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Kingfisher

class GifFullScreenViewController: UIViewController
{
    
    var giphy : Datum?

    @IBOutlet weak var imgGif: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //
        let url = giphy?.images.original.url
        imgGif.kf.setImage(with:URL(string:url ?? ""), placeholder:nil)
    }
}
