//
//  SignInViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 17.01.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SignInViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: TextFieldWithPadding!
    @IBOutlet weak var passwordTextField: TextFieldWithPadding!
    @IBOutlet weak var signinButton: UIButton!
    
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var dontHaveAccLabel: UILabel!
    @IBOutlet weak var registButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViews()
        hideKeyboardWhenTappedAround()
    }
    
    func configureViews(){
        helloLabel.text = "HELLO".localized()
        subtitleLabel.text = "SIGN_INTO_YOUR_ACCOUNT".localized()
        passwordLabel.text = "PASSWORD".localized()
        dontHaveAccLabel.text = "DONT_HAVE_AN_ACCAOUNT?".localized()
        registButton.setTitle("REGISTRATION".localized(), for: .normal)
        emailTextField.placeholder = "YOUR_EMAIL".localized()
        passwordTextField.placeholder = "YOUR_PASSWORD".localized()
        signinButton.setTitle("SIGN_IN".localized(), for: .normal)
        
        
        emailTextField.layer.cornerRadius = 12.0
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        passwordTextField.layer.cornerRadius = 12.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        signinButton.layer.cornerRadius = 12.0
        
    }
    
    
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
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
    
    
    @IBAction func signin(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        SVProgressHUD.show()
        
        let parameters = ["email": email, "password": password]
        
        AF.request(Urls.SIGN_IN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
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
                    UserDefaults.standard.set(email, forKey: "email")
                    self.startApp()
                    
                }else{
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            }
        }
    }
    
    func startApp(){
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController")
        tabViewController?.modalPresentationStyle = .fullScreen
        self.present(tabViewController!, animated: true, completion: nil)
    }
    
    @IBAction func registration(_ sender: Any) {
        let registrationVC = storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationViewController
        navigationController?.show(registrationVC, sender: self)
        
    }
    
    func updatePersonalInfo(){
        let personalInfoVC = storyboard?.instantiateViewController(withIdentifier: "PersonalInfoViewController") as! PersonalInfoViewController
        
        var name = ""
        var email = emailTextField.text!
        
        for i in email {
            if i == "@"{
                break
            }else{
                name.append(i)
            }
        }
        personalInfoVC.nameTextfield.text = name
        

        let parameters = ["email": email, "name": name]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]

        AF.request(Urls.PROFILE_UPDATE_URL, method: .put, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                let json = JSON(response.data!)
                print("JSON: \(json)")

                personalInfoVC.nameTextfield.text = json["name"].string
                personalInfoVC.emailTextfield.text = json["user"]["email"].string
               
                

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
