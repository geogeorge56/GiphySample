//
//  FavoriteViewController.swift
//  GifySampleProject
//
//  Created by user on 15/02/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit


class FavoriteViewController: UIViewController {
    
    var favoritesArr = [Favorite]()
    
    @IBOutlet weak var cvFavorites: UICollectionView!{
        didSet{
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top:0,left:7,bottom:0,right:7)
            let screenWidth = (UIScreen.main.bounds.width / 3) - 6
            layout.itemSize = CGSize(width: screenWidth, height: screenWidth)
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
            cvFavorites.collectionViewLayout = layout
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        if let favorites = DataLayer.sharedInstance.getAllFavorites(){
            self.favoritesArr = favorites
            self.cvFavorites.reloadData()
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.cvFavorites.collectionViewLayout.invalidateLayout()
    }
    
    
}

extension FavoriteViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath){
       // self.presentPhotoBrowser()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return favoritesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = cvFavorites.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.className, for: indexPath) as! FavoriteCollectionViewCell
        let favorite = favoritesArr[indexPath.row]
        cell.setFavoriteDetail(from: favorite)
        
        return cell
    }
    

}
