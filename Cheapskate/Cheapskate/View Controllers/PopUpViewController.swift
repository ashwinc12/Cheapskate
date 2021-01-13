//
//  PopUpViewController.swift
//  Cheapskate
//
//  Created by Ashwin Chitoor on 1/8/21.
//

import UIKit
import Foundation
import Firebase

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var itemTextField: UITextField!
    
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTextField.backgroundColor = .white
        itemTextField.textColor = .black
        
        costTextField.backgroundColor = .white
        costTextField.textColor = .black
        Utilities.styleSubmitButton(submitButton)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        let numbersOnly = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: costTextField.text!))
        
        if (numbersOnly) {
            updateData(item: itemTextField.text!, cost: Int(costTextField.text!) ?? 0)
            
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    func updateData( item: String, cost: Int) {
        let key =  "receipt" + "." + item
        let db = Firestore.firestore()
        
        db.collection("users").whereField("uid", isEqualTo: user.uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error finding group: \(err)")
                } else {
                    let document = querySnapshot!.documents.first
                    document!.reference.updateData([
                        key : cost
                                ])
                }
            }
    }

}
