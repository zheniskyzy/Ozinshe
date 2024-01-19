//
//  RegistrationViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 18.01.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON


class RegistrationViewController: UIViewController {


    
    @IBOutlet weak var emailTextField: TextFieldWithPadding!
    @IBOutlet weak var passwordTextField: TextFieldWithPadding!
    @IBOutlet weak var repeatPasswordTextField: TextFieldWithPadding!
    @IBOutlet weak var registrationButton: UIButton!
    
    
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var doYouHaveAccLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViews()
       
    }
    func configureViews(){
       
        emailTextField.placeholder = "YOUR_EMAIL".localized()
        passwordTextField.placeholder = "YOUR_PASSWORD".localized()
        repeatPasswordTextField.placeholder = "YOUR_PASSWORD".localized()
        registrationButton.setTitle("REGISTRATION".localized(), for: .normal)
        registrationLabel.text = "REGISTRATION".localized()
        subtitleLabel.text = "FILL_IN_THE_DATA".localized()
        passwordLabel.text = "PASSWORD".localized()
        repeatPasswordLabel.text = "REPEAT_PASSWORD".localized()
        doYouHaveAccLabel.text = "DO_YOU_HAVE_AN_ACC".localized()
        enterButton.setTitle("SIGN_IN".localized(), for: .normal)
        
        
        
        
        emailTextField.layer.cornerRadius = 12.0
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        passwordTextField.layer.cornerRadius = 12.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        repeatPasswordTextField.layer.cornerRadius = 12.0
        repeatPasswordTextField.layer.borderWidth = 1.0
        repeatPasswordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        registrationButton.layer.cornerRadius = 12.0
        
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func showPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func showRepeatedPassword(_ sender: Any) {
        repeatPasswordTextField.isSecureTextEntry = !repeatPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func registration(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        SVProgressHUD.show()
        let parameters = ["email": email, "password": password]
        AF.request(Urls.SIGN_UP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
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
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    self.startApp()
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
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController")
        tabViewController?.modalPresentationStyle = .fullScreen
        self.present(tabViewController!, animated: true, completion: nil)
    }
    
  
    
    @IBAction func enterToAcc(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
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
