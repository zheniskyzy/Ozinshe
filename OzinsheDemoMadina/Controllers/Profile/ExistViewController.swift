//
//  ExistViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 17.01.2024.
//

import UIKit

class ExistViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var existLabel: UILabel!
    @IBOutlet weak var existubtitleLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundView.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        configureViews()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }


    @objc func dismissView(){
         self.dismiss(animated: true,completion: nil)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if (touch.view?.isDescendant(of: backgroundView))!{
         return false
    }
         return true
    }
    
    
    func configureViews(){
        existLabel.text = "EXIST".localized()
        existubtitleLabel.text = "EXIST_SUBTITLE".localized()
        yesButton.setTitle("YES".localized(), for: .normal)
        noButton.setTitle("NO".localized(), for: .normal)
    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer){
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1,options: .curveEaseOut, animations: {
                self.backgroundView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 100{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.backgroundView.transform = .identity
                })
            }else{
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @IBAction func logoutYes(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInNavigationController") as! UINavigationController
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func cancelNoButton(_ sender: Any) {
        dismissView()
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
