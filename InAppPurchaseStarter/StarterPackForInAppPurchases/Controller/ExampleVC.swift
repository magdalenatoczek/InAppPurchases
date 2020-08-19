//
//  ExampleVC.swift
//  InAppPurchaseStarter
//
//  Created by Magdalena Toczek on 19/08/2020.
//  Copyright © 2020 Popeq Apps. All rights reserved.
//

import UIKit


class ExampleVC: UIViewController, InAppPuchaseServiceDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //check if the payment was made - from UserDefaults ->  let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        //if purchaseStatus true showContent()
        
        
        
        InAppPuchaseService.INSTANCE.delegate = self
        InAppPuchaseService.INSTANCE.loadProducts()

        // Do any additional setup after loading the view.
    }
    
    func productLoaded(){
            print("product loaded correctly")
    }


  
//@IBAction
func buyButtonPressed(_sender: Any){
    InAppPuchaseService.INSTANCE.purchaseForItem(productIndex: .firstProductType)
}



//@IBAction
func restoreButton(_sender: Any){
    
    

}



}
