//
//  LoginViewController.swift
//  Happystagram
//
//  Created by 市川龍星 on 2018/09/04.
//  Copyright © 2018年 市川龍星. All rights reserved.
//

// mainstoryboard


import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createNewUser(_ sender: Any) {
        
        if emailTextField.text == nil, passwordTextField == nil {
            let alertViewController = UIAlertController(title: "おっと", message: "入力欄が空です", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
// okActionと言うアクションをalertViewControllerに追加
            alertViewController.addAction(okAction)
            present(alertViewController, animated: true, completion: nil)
        } else{
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
            
            if error == nil {
                
            }else{
//                失敗
                
            }
        }
      }
    }
    
    @IBAction func userLogIn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
            
            if error == nil {
                
            }else{
                //                失敗
                let alertViewController = UIAlertController(title: "おっと", message: error?.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                alertViewController.addAction(okAction)
                self.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
    

}
