//
//  ExampleNonConsumableVC.swift
//  InAppPurchaseStarter
//
//  Created by Magdalena Toczek on 21/08/2020.
//  Copyright © 2020 Popeq Apps. All rights reserved.
//

import UIKit

class ExampleNonConsumableVC: UIViewController {

   override func viewDidLoad() {
            super.viewDidLoad()
            
    
            //first check status
            let purchaseStatus = UserDefaults.standard.bool(forKey: ProductType.exampleBuyNonConsumable.rawValue)
            if purchaseStatus {
              //  showHideContentAndAdjustTheView()
            }
          
            NotificationCenter.default.addObserver(self, selector: #selector(handlePurchase(_:)), name: NSNotification.Name(notificationPurchaseFromInAppService), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleFailure(_:)), name: NSNotification.Name(notificationFailureFromInAppService), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleRestore(_:)), name: NSNotification.Name(notificationRestoreFromInAppService), object: nil)
            
        
        }


    deinit {
               NotificationCenter.default.removeObserver(self)
           }
    
        @objc func handlePurchase(_ notification: Notification){
            guard let productId = notification.object as? String else { return }
                  if productId == ProductType.exampleBuyNonConsumable.rawValue {
                        UserDefaults.standard.set(true, forKey: productId)
                            //  showHideContentAndAdjustTheView()
             }
            }
        
        
        @objc func handleRestore(_ notification: Notification){
             
             guard let productId = notification.object as? String else { return }
             if productId == ProductType.exampleBuyNonConsumable.rawValue {
                         UserDefaults.standard.set(true, forKey: productId)
                             //  showHideContentAndAdjustTheView()
                                //hide restore button
              }
             }
       

        @objc func handleFailure(_ notification: Notification){
        //  buyButton.isEnabled = true //to protect cliking multiple times during buy operation
        //  hideAdsButton.isEnabled = true
            debugPrint("purchaseFailed!")

           }
        

    // EXAMPLE BUTTONS

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
