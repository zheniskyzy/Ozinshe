//
//  ChangePasswordViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 17.01.2024.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var repeatpasswordLabel: UILabel!
    @IBOutlet weak var passwordTextfield: TextFieldWithPadding!
    @IBOutlet weak var repeatpasswordTextfield: TextFieldWithPadding!
    @IBOutlet weak var savechangesButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        savechangesButton.addTarget(self, action: #selector(closeView), for: .touchDown)
//    }
   
    func configureViews(){
        title = "CHANGE_PASSWORD".localized()
        repeatpasswordLabel.text = "REPEAT_PASSWORD".localized()
        passwordTextfield.placeholder = "YOUR_PASSWORD".localized()
        repeatpasswordTextfield.placeholder = "YOUR_PASSWORD".localized()
        savechangesButton.setTitle("SAVE_CHANGES".localized(), for: .normal)
        
        passwordTextfield.layer.cornerRadius = 12.0
        passwordTextfield.layer.borderWidth = 1.0
        passwordTextfield.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        repeatpasswordTextfield.layer.cornerRadius = 12.0
        repeatpasswordTextfield.layer.borderWidth = 1.0
        repeatpasswordTextfield.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        let password = passwordTextfield.text!
        
        SVProgressHUD.show()
        
        let parameters = ["password": password]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]

        AF.request(Urls.CHANGE_PASSWORD_URL, method: .put, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseData { response in

            SVProgressHUD.dismiss()
            
            var resultString = ""
            
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200{
                let json = JSON(response.data!)
                print("JSON: \(json)")

                if let token = json["accessToken"].string{
                    Storage.sharedInstance.accessToken = token
                    self.startApp()
//                    UserDefaults.standard.set(token, forKey: "accessToken")
//                    UserDefaults.standard.set(password, forKey: "password")
                    
                }else{
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            }else{
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode{
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
        
    }
    
    func startApp(){
        
        self.navigationController?.popViewController(animated: true)
 
    }
    
    @IBAction func textFieldDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    
    
    @IBAction func textFieldDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
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
