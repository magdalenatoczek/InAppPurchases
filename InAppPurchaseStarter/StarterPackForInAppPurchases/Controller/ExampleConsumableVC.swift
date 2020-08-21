//
//  ExampleVC.swift
//  InAppPurchaseStarter
//
//  Created by Magdalena Toczek on 19/08/2020.
//  Copyright © 2020 Popeq Apps. All rights reserved.
//

import UIKit


class ExampleConsumableVC: UIViewController, InAppPurchaseServiceDelegate {
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false

        InAppPuchaseService.INSTANCE.inAppPurchaseServiceDelegate = self
        InAppPuchaseService.INSTANCE.loadProducts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchase(_:)), name: NSNotification.Name(notificationPurchaseFromInAppService), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFailure(_:)), name: NSNotification.Name(notificationFailureFromInAppService), object: nil)

    }
    
    deinit {
          NotificationCenter.default.removeObserver(self)
      }

    
    @objc func handlePurchase(_ notification: Notification){
        guard let productId = notification.object as? String else { return }
                if productId == ProductType.exampleBuyConsumable.rawValue {
                    //adjust layout , add points et cereta
        }
    }
    
    @objc func handleFailure(_ notification: Notification){
    //  buyButton.isEnabled = true //to protect cliking multiple times during buy operation
    //  hideAdsButton.isEnabled = true
        debugPrint("purchase Failed!")
       }
    

// EXAMPLE BUTTONS
//@IBAction
func buyButtonPressed(_sender: Any){
  //  buyButton.isEnabled = false //to protect cliking multiple times during buy operation
    InAppPuchaseService.INSTANCE.makePurchaseForItem(forProductId: ProductType.exampleBuyConsumable.rawValue)
 
}
    
    func loadProductsDelegate() {
           view.isUserInteractionEnabled = true
       }
       
    
    
    
    
}
