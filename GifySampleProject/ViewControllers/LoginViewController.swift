//
//  LoginViewController.swift
//  GifySampleProject
//
//  Created by user on 19/03/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var tftPassword: BorderedTextField!
    @IBOutlet weak var tftEmail: BorderedTextField!
    
    @IBOutlet weak var scrollViewBotomConstraint: NSLayoutConstraint!
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addKeyBoardListerners()
        addImage(image: "user", to: tftEmail)
        addImage(image: "padlock", to: tftPassword)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    func addImage(image name:String,to textField:UITextField)
    {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: name)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: textField.frame.size.height))
        view.addSubview(imageView)
        imageView.center = view.center
        textField.leftView = view
        textField.leftViewMode = .always
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
        scrollViewBotomConstraint.constant = keyboardHeight
    }
    
      /*
      * Keyboard hidden
      */
     @objc func keyboardWillDisappear()
     {
         scrollViewBotomConstraint.constant = 0
     }
    
     /*
      * Validates whether user name and password entered
      */
    func validation()-> Bool
    {
        guard let email = tftEmail.text,!email.isEmpty else
        {
            CommonFunctions.sharedInstance.showAlert(in: self, with: Constants.Messages.ENTER_EMAIL)
            return false
        }
        guard let password = tftPassword.text,!password.isEmpty else
        {
            CommonFunctions.sharedInstance.showAlert(in: self, with: Constants.Messages.ENTER_PASSWORD)
            return false
        }
        return true
    }
    
    
    
    /*
     * Passes email and password to firebase and authenticates
     */
    @IBAction func loginAction(_ sender: Any)
    {
        if(validation())
        {
            Auth.auth().signIn(withEmail: tftEmail.text!, password: tftPassword.text!) { [weak self] authResult, error in
              guard let strongSelf = self else { return }
                
                if error != nil
                {
                    CommonFunctions.sharedInstance.showAlert(in: strongSelf, with: error!.localizedDescription)
                }
                else
                {
                    strongSelf.login()
                }
            }
        }
        
    }
    
    
    /*
     * After sucessfull authetification navigates to the root view
     */
    func login()
    {
        UserDefaults.standard.set(true, forKey: "Login") //Bool
        UserDefaults.standard.synchronize()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = rootController
    }
    

}


