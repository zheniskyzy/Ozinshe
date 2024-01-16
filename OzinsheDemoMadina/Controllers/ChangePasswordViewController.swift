//
//  ChangePasswordViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 17.01.2024.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var repeatpasswordLabel: UILabel!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var repeatpasswordTextfield: UITextField!
    @IBOutlet weak var savechangesButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews(){
        title = "CHANGE_PASSWORD".localized()
        repeatpasswordLabel.text = "REPEAT_PASSWORD".localized()
        passwordTextfield.placeholder = "YOUR_PASSWORD".localized()
        repeatpasswordTextfield.placeholder = "YOUR_PASSWORD".localized()
        savechangesButton.setTitle("SAVE_CHANGES".localized(), for: .normal)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
