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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViews()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
