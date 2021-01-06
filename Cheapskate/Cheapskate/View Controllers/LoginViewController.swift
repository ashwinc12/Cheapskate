//
//  LoginViewController.swift
//  Cheapskate
//
//  Created by Ashwin Chitoor on 1/6/21.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        self.view.backgroundColor = UIColor.init(red: 232/255, green: 206/255, blue: 191/255, alpha: 1)

        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(loginButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func loginTapped(_ sender: Any) {
        let emailEmpty = emailTextField.text!.isEmpty
        let passwordEmpty = passwordTextField.text!.isEmpty
       
        if (emailEmpty && passwordEmpty)  {
            errorLabel.alpha = 1
            errorLabel.text = "Please fill in your email and password"
        } else if (emailEmpty) {
            errorLabel.alpha = 1
            errorLabel.text = "Please fill in your email"
        } else if (passwordEmpty) {
            errorLabel.alpha = 1
            errorLabel.text = "Please fill in your password"
        } else {

        
            
        // Sign into user
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                let homeViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?
                    HomeViewController
                 
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        
        
     }
    }
    
    
}
