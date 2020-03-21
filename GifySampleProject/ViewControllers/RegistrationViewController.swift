//
//  RegistrationViewController.swift
//  GifySampleProject
//
//  Created by user on 19/03/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import FirebaseAuth


class RegistrationViewController: UIViewController{
    
    
    @IBOutlet weak var tftEmail: BorderedTextField!
    @IBOutlet weak var tftPassword: BorderedTextField!
    @IBOutlet weak var tftConfirmPassword: BorderedTextField!
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addKeyBoardListerners()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
           super.viewWillAppear(true)
           self.view.endEditing(true)
           self.navigationController?.setNavigationBarHidden(true, animated: false)
           
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
           scrollViewBottomConstraint.constant = keyboardHeight
       }
       
       /*
         * Keyboard hidden
         */
        @objc func keyboardWillDisappear()
        {
            scrollViewBottomConstraint.constant = 0
        }
       
    /*
     * Register user useing firebase
     */
    @IBAction func registerButtonClicked(_ sender: Any)
    {
        self.view.endEditing(true)
        if(validation())
        {
            Auth.auth().createUser(withEmail: tftEmail.text!, password: tftPassword.text!, completion: { (user, error) in
                        if error != nil
                        {
                            CommonFunctions.sharedInstance.showAlert(in: self, with: error!.localizedDescription)
                        }
                        else
                        {
                            let alertController = UIAlertController(title: "Alert", message: Constants.Messages.REGISTRATION_SUCESSFULL, preferredStyle: .alert)

                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                            {
                                   UIAlertAction in
                            self.navigationController?.popViewController(animated: true)

                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
            })
        }
        
    }
    
    /*
     * Validates whether email,password and confirm password entered,also email validation and chekcs match between password and confirm password
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
        guard let confirmPassword = tftConfirmPassword.text, !confirmPassword.isEmpty else
        {
            CommonFunctions.sharedInstance.showAlert(in: self, with: Constants.Messages.ENTER_CONFIRM_PASSWORD)
                return false
        }
        if(tftPassword.text != tftConfirmPassword.text)
        {
            CommonFunctions.sharedInstance.showAlert(in: self, with: Constants.Messages.PASSWORD_DOESNT_MATCH)
            return false
        }
        if(!CommonFunctions.sharedInstance.isValidEmail(email: tftEmail.text!))
        {
            CommonFunctions.sharedInstance.showAlert(in: self, with: Constants.Messages.ENTER_VALID_EMAIL)
            return false
        }
        return true
    }
    
   
    
    @IBAction func loginButtonClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}
