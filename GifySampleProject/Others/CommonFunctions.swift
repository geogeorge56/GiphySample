//
//  CommonFunctions.swift
//  GifySampleProject
//
//  Created by user on 20/03/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class CommonFunctions: NSObject
{
    static let sharedInstance = CommonFunctions()
    
    func showAlert(in viewController:UIViewController,with message:String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }
    
    func isValidEmail(email: String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
