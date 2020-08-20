//
//  ExampleVC.swift
//  InAppPurchaseStarter
//
//  Created by Magdalena Toczek on 19/08/2020.
//  Copyright © 2020 Popeq Apps. All rights reserved.
//

import UIKit


class ExampleVC: UIViewController {
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let purchaseStatus = UserDefaults.standard.bool(forKey: ProductType.exampleBuyNonConsumable.rawValue)
        if purchaseStatus {
          //  showHideContentAndAdjustTheView()
        }
      
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchase(_:)), name: NSNotification.Name(notificationPurchaseFromInAppService), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFailure(_:)), name: NSNotification.Name(notificationFailureFromInAppService), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRestore(_:)), name: NSNotification.Name(notificationRestoreFromInAppService), object: nil)
        
    
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    @objc func handlePurchase(_ notification: Notification){
        
        guard let productId = notification.object as? String else { return }
        
        switch productId {
        case ProductType.exampleBuyConsumable.rawValue:
             //  buyButton.isEnabled = true //to protect cliking multiple times during buy operation
            break
        case ProductType.exampleBuyNonConsumable.rawValue:
            UserDefaults.standard.set(true, forKey: productId)
            
            
            break
            
        default:
            break
            
        }
        
        
    }
    
    @objc func handleRestore(_ notification: Notification){
         
         guard let productId = notification.object as? String else { return }
         
         switch productId {
         case ProductType.exampleBuyNonConsumable.rawValue:
             UserDefaults.standard.set(true, forKey: productId)
             //  showHideContentAndAdjustTheView()
             break
         default:
             break
             
         }

     }
    
    
    
    
    
    
    @objc func handleFailure(_ notification: Notification){
    //  buyButton.isEnabled = true //to protect cliking multiple times during buy operation
    //  hideAdsButton.isEnabled = true
        print("purchaseFailed!")
           
       }
    

// EXAMPLE BUTTONS
  
//@IBAction
func buyButtonPressed(_sender: Any){
  //  buyButton.isEnabled = false //to protect cliking multiple times during buy operation
    InAppPuchaseService.INSTANCE.makePurchaseForItem(forProductId: ProductType.exampleBuyConsumable.rawValue)
 
}

//IBAction
func hideAds(_sender: Any) {
        //hideAdsButton.isEnabled = false
        InAppPuchaseService.INSTANCE.makePurchaseForItem(forProductId: ProductType.exampleBuyNonConsumable.rawValue)

    }

//@IBAction
func restoreButton(_sender: Any){
    InAppPuchaseService.INSTANCE.restore()

}



  
    

}
