//
//  GiphyTableViewCell.swift
//  GifySampleProject
//
//  Created by user on 14/02/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Kingfisher

class GiphyTableViewCell: UITableViewCell {
    @IBOutlet weak var imgGiphy: UIImageView!
    
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setGiphyDetails(from giphy:Datum)
    {
        lblTitle.text = giphy.title
        let imageUrl = giphy.images.downsized.url
        imgGiphy.kf.setImage(with:URL(string: imageUrl), placeholder:nil)
        
    }
    
    func setFavImageFrom(from giphy:Datum){
        
            //setting background color for button based on favorite or not
        if DataLayer.sharedInstance.getFavoriteGiphyWith(id: giphy.id) != nil{
            btnFavorite.setImage(#imageLiteral(resourceName: "ic_selected"), for: UIControl.State.normal)
        }else{
            btnFavorite.setImage(#imageLiteral(resourceName: "ic_unselected"), for: UIControl.State.normal)
        }
    }

}
