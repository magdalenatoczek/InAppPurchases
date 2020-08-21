//
//  ExampleSubscriptionVC.swift
//  InAppPurchaseStarter
//
//  Created by Magdalena Toczek on 20/08/2020.
//  Copyright © 2020 Popeq Apps. All rights reserved.
//

import UIKit

class ExampleSubscriptionVC: UIViewController, InAppPurchaseServiceDelegate  {
    
    
    var validSubscription = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isUserInteractionEnabled = false
  
        InAppPuchaseService.INSTANCE.inAppPurchaseServiceDelegate = self
        InAppPuchaseService.INSTANCE.loadProducts()
        
        let status = UserDefaults.standard.bool(forKey: ProductType.exampleOfSubscription.rawValue)

            if status {
                validSubscription = true
                let expiredTime = UserDefaults.standard.value(forKey: "expirationDate") as? Date
                debugPrint(expiredTime!)
              //  showHideContentAndAdjustTheView()
            }

          NotificationCenter.default.addObserver(self, selector: #selector(handleSubscription(_:)), name: NSNotification.Name(notificationSubscribeChangeInAppService), object: nil)

    }
    
    
    
    
    deinit {
          NotificationCenter.default.removeObserver(self)
      }
    

    @objc func handleSubscription(_ notification: Notification){
         guard let status = notification.object as? SubscribeStatus else { return }
               
        DispatchQueue.main.async{  //becouse notification was send on the back thread and we want to change layout!
            switch status {
            case .active:
                UserDefaults.standard.set(true, forKey: ProductType.exampleOfSubscription.rawValue)
                    self.validSubscription = true
                               //  showHideContentAndAdjustTheView()
                //put info about remaining time
                break
            case .inactive:
                UserDefaults.standard.set(false, forKey: ProductType.exampleOfSubscription.rawValue)
                self.validSubscription = false
                           //  showHideContentAndAdjustTheView()
                        
                break
            case .expired:
                UserDefaults.standard.set(false, forKey: ProductType.exampleOfSubscription.rawValue)
                self.validSubscription = false
                           //  showHideContentAndAdjustTheView()
                break
            }
        }
    }
    


    
    //@IBAction
    func buySubscriptionButtonPressed(_sender: Any){
      //  buyButton.isEnabled = false //to protect cliking multiple times during buy operation
        InAppPuchaseService.INSTANCE.makePurchaseForItem(forProductId: ProductType.exampleOfSubscription.rawValue)
     
    }
    
    func loadProductsDelegate() {
           view.isUserInteractionEnabled = true
       }
       

}
