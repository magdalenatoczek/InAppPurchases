//
//  ExampleSubscriptionVC.swift
//  InAppPurchaseStarter
//
//  Created by Magdalena Toczek on 20/08/2020.
//  Copyright © 2020 Popeq Apps. All rights reserved.
//

import UIKit

class ExampleSubscriptionVC: UIViewController {
    
    
    var validSubscription = false

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let status = UserDefaults.standard.bool(forKey: ProductType.exampleBuyNonConsumable.rawValue)
        if status {
            validSubscription = true
          //  showHideContentAndAdjustTheView()
        }
        
        
          NotificationCenter.default.addObserver(self, selector: #selector(handleSubscription(_:)), name: NSNotification.Name(notificationSubscribeChangeInAppService), object: nil)
        
        
     
    }
    
    
    
    @objc func handleSubscription(_ notification: Notification){
         guard let productId  = notification.object as? String else { return }
        if productId == ProductType.exampleOfAutoRenewingSubscription.rawValue{
            UserDefaults.standard.set(true, forKey: productId)
            validSubscription = true
            //  showHideContentAndAdjustTheView()
        }
        
        
    }
    


    
    //@IBAction
    func buyAutoRenewableSubscriptionButtonPressed(_sender: Any){
      //  buyButton.isEnabled = false //to protect cliking multiple times during buy operation
        InAppPuchaseService.INSTANCE.makePurchaseForItem(forProductId: ProductType.exampleOfAutoRenewingSubscription.rawValue)
     
    }
    
    
    

}
