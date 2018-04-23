//
//  ViewController.swift
//  Custom_Payment_Stripe
//
//  Created by HigherVisibility on 31/03/2018.
//  Copyright © 2018 ahmedHigherVisibility. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class ViewController: UIViewController,STPPaymentCardTextFieldDelegate {
    
 let paymentTextField = STPPaymentCardTextField()
    let baseURL = "https://stripebuzybeez.herokuapp.com/"
    @IBOutlet weak var pay_btn_outlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let frame = CGRect(x: 15, y: 199, width:(self.view.frame.width) - 30, height: 100)
        paymentTextField.frame = frame
        paymentTextField.delegate = self
        self.view.addSubview(paymentTextField)
        pay_btn_outlet.isHidden = true
        
    }
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        self.pay_btn_outlet.isHidden = false
        self.BuyBtn()
    }
    
    func BuyBtn()  {
        self.pay_btn_outlet.layer.cornerRadius = pay_btn_outlet.frame.height/2
        self.pay_btn_outlet.setTitleColor(.black, for: .normal)
        
        self.pay_btn_outlet.layer.shadowColor = UIColor.black.cgColor
        self.pay_btn_outlet.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.pay_btn_outlet.layer.shadowRadius = 3
        self.pay_btn_outlet.layer.shadowOpacity = 0.5
    }
    @IBAction func pay_btn_Action(_ sender: Any) {
        
        let card = paymentTextField.cardParams
        
        STPAPIClient.shared().createToken(withCard: card) { (token, error) in
            
            if error != nil {
                
            print(error!.localizedDescription)
                
            }
            else if let token = token {
                
                print(token)
                self.chargeUsingToken(token: token)
                
                
            }
            
            
        }
        

    }
    
    func chargeUsingToken(token:STPToken) {
       
        let url = "https://stripebuzybeez.herokuapp.com/charge"
        let params: [String: Any] = [
            "StripeToken": token,
            "amount": "2",
            "currency" : "GBP",
            "description" : "Charge for test@example.com",
           // "receipt_email" : "rehansplash@gmail.com"
           
            //result.source.stripeID
        ]
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                   
                    print("success")
                    
                case .failure(let error):
                    print("failure \(error)")
                    
                }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

