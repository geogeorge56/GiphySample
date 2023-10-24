//
//  TrendingFeedViewController.swift
//  GifySampleProject
//
//  Created by user on 13/02/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import FirebaseAuth

class TrendingFeedViewController: UIViewController,UIWebViewDelegate
{

    @IBOutlet weak var tblTrending: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
    
    var giphyModelArr = [Datum]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let mainContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    private let searchController = UISearchController(searchResultsController: nil)
    
    var searchText = ""
    var currentIndex = -1 {
        willSet{
            self.isFetchedAll = self.currentIndex == -1 ? false : true
        }
    }
    var limit = 20
    var isFetchedAll = false
    var isTrendingCalled = false
    
    
    override func viewDidLoad(){
        super.viewDidLoad()

        initialSetup()
        
    }
    
    /*
    * Initial view setups
    */
    func initialSetup()
    {
        searchController.searchResultsUpdater = self
          tblTrending.tableHeaderView = searchController.searchBar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        addKeyBoardListerners()
        fetchTrendingGiphys()
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /*
     * Adding listerners for showing and hiding keyboard
     */
    func  addKeyBoardListerners()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    /*
     * Keyboard shown
     */
    @objc func keyboardWillAppear(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        tblBottomConstraint.constant = keyboardHeight
    }
    
    /*
     * Keyboard hidden
     */
    @objc func keyboardWillDisappear()
    {
        tblBottomConstraint.constant = 0
    }
    
    /*
     * Fetches trending gifs from server
     */
    func fetchTrendingGiphys(){
        
        isTrendingCalled = true
        activityIndicator.isHidden = false
        currentIndex += 1
        NetworkLayer.sharedInstance.trending(limit: limit, offset: currentIndex * limit) { [weak self] (giphyDataArr, error) in
            
            guard let weakSelf = self else { return }
            weakSelf.giphyModelArr.append(contentsOf: giphyDataArr)
            weakSelf.isFetchedAll =  giphyDataArr.count <= weakSelf.limit ? false : true
            DispatchQueue.main.async{
                weakSelf.tblTrending.reloadData();
                weakSelf.activityIndicator.isHidden = true
            }
            
        }
        
        
    }
    
    /*
     * Fetches searched gifs from server
     */
    func fetchSearchGiphy(){
        
        isTrendingCalled = false
        activityIndicator.isHidden = false
        currentIndex += 1
        NetworkLayer.sharedInstance.searchGify(searchText: searchText, limit: limit, offset: 0) { [weak self] (giphyDataArr, error,searchTxt) in
            
            guard let weakSelf = self else { return }
            if weakSelf.searchText == searchTxt{
                weakSelf.giphyModelArr.append(contentsOf: giphyDataArr)
                weakSelf.isFetchedAll =  giphyDataArr.count <= weakSelf.limit ? false : true
                DispatchQueue.main.async{
                    weakSelf.tblTrending.reloadData();
                    weakSelf.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    /*
     * Fetches trending gifs from server
     */
    @objc func favoriteClicked(sender: UIButton)
    {
        let giphy = giphyModelArr[sender.tag]
        let favGiphy = DataLayer.sharedInstance.getFavoriteGiphyWith(id: giphy.id)
        //if user tapped on a already favroite object delete it from local db as favorite otherwise add it to local as favorite
        if(favGiphy != nil)
        {
            DataLayer.sharedInstance.deleteFavoriteGiphy(with: giphy.id)
        }
        else
        {
            DataLayer.sharedInstance.saveGiphyData(from: giphy)
        }
        
        
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let cell: GiphyTableViewCell = self.tblTrending.cellForRow(at: indexPath as IndexPath) as! GiphyTableViewCell
        cell.setFavImageFrom(from: giphy)
        self.tblTrending.reloadData()
        
    }
    
    @IBAction func logoutAction(_ sender: Any)
    {
        let firebaseAuth = Auth.auth()
        do
        {
          try firebaseAuth.signOut()
        }
        catch let signOutError
        {
         CommonFunctions.sharedInstance.showAlert(in: self, with: signOutError as! String)
          return
        }
        UserDefaults.standard.set(false, forKey: "Login")
        UserDefaults.standard.synchronize()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyboard.instantiateViewController(withIdentifier: "LoginNavController") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = rootController
        
    }
    
    
    
    
    
}
extension TrendingFeedViewController:UITableViewDelegate,UITableViewDataSource
{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return giphyModelArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = self.tblTrending.dequeueReusableCell(withIdentifier: "giphyCell", for: indexPath) as! GiphyTableViewCell
        let giphyData = giphyModelArr[indexPath.row]
        cell.btnFavorite.addTarget(self, action: #selector(favoriteClicked(sender:)), for: .touchUpInside)
        cell.btnFavorite.tag = indexPath.row
        cell.setGiphyDetails(from: giphyData)
        cell.setFavImageFrom(from: giphyData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        searchController.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: false)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: GifFullScreenViewController.className) as! GifFullScreenViewController
        let giphyData = giphyModelArr[indexPath.row]
        nextViewController.giphy = giphyData
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == giphyModelArr.count - 5 && !isFetchedAll{
            fetchTrendingGiphys()
        }
    }
}

extension TrendingFeedViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController){
        
        searchText = searchController.searchBar.text!
        if searchText.count > 0
        {
            currentIndex = -1
            self.giphyModelArr.removeAll()
            self.tblTrending.reloadData()
            self.fetchSearchGiphy()
        }
        else
        {
            currentIndex = -1
            searchText = ""
            if isTrendingCalled == false
            {
                self.giphyModelArr.removeAll()
                self.tblTrending.reloadData()
                self.fetchTrendingGiphys()
            }
        }
    }
}


