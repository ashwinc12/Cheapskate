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

    let defaults = UserDefaults.standard

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
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tintColor = .black

        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
        emailTextField.tintColor = .black

        
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
//        let emailEmpty = emailTextField.text!.isEmpty
//        let passwordEmpty = passwordTextField.text!.isEmpty
//
//        if (emailEmpty && passwordEmpty)  {
//            errorLabel.alpha = 1
//            errorLabel.text = "Please fill in your email and password"
//        } else if (emailEmpty) {
//            errorLabel.alpha = 1
//            errorLabel.text = "Please fill in your email"
//        } else if (passwordEmpty) {
//            errorLabel.alpha = 1
//            errorLabel.text = "Please fill in your password"
//        } else {

        // Sign into user
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if (!isLoggedIn) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
            UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
            UserDefaults.standard.synchronize()
            
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
          }
            storeLocalData(email: emailTextField.text!)
        } else {
            storeLocalData(email: UserDefaults.standard.string(forKey: "email")!)
        }
    }
    
    func storeLocalData( email : String) {
        // Check if there is a group
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error finding group: \(err)")
                } else {
                    // Store data
                    for document in querySnapshot!.documents {
                        let dictionary : NSDictionary = document.data() as NSDictionary
                        user.firstName = dictionary["firstname"] as! String
                        user.lastName = dictionary["lastname"] as! String
                        user.email = dictionary["email"] as! String
                        user.groupId = dictionary["groupid"] as! String
                        user.uid = dictionary["uid"] as! String
                        user.receipt = dictionary["receipt"] as! Dictionary
                        
                    }
                    
                    db.collection("groups").whereField("groupid", isEqualTo: user.groupId)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting groupmates \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let dictionary : NSDictionary = document.data() as NSDictionary
                                    // Don't want to mark ourselves as part of the group
                                    let member1 = dictionary["member1"] as! String
                                    let member2 = dictionary["member2"] as! String
                                    let member3 = dictionary["member3"] as! String
                                    let member4 = dictionary["member4"] as! String
                                    
                                    if member1 != user.uid {
                                        user.group.append(member1)
                                    }
                                    if member2 != user.uid {
                                        user.group.append(member2)
                                    }
                                    if member3 != user.uid {
                                        user.group.append(member3)
                                    }
                                    if member4 != user.uid {
                                        user.group.append(member4)
                                    }
                                }
                                
                            }
                    }
                }
            }
    }
    func transitionToHome() {
//        let homeViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as?
//            HomeViewController
//
//        self.view.window?.rootViewController = homeViewController
//        self.view.window?.makeKeyAndVisible()
    }
}
