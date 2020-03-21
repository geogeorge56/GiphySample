//
//  FavoriteCollectionViewCell.swift
//  GifySampleProject
//
//  Created by user on 15/02/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    func setFavoriteDetail(from favorite:Favorite){
        imgFavorite.kf.setImage(with:URL(string: favorite.url ?? ""), placeholder:nil)
    }
    
}
