//
//  AlertPopup.swift
//  OnTheMap
//
//  Created by jay raval on 8/18/17.
//  Copyright © 2017 jay raval. All rights reserved.
//

import UIKit

extension UIViewController{
    func displayAlert(_ title:String,_ message:String){
        
    let alertController=UIAlertController(title:title, message:message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil)
    }

}
