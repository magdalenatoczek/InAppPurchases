//
//  InAppPuchaseServise.swift
//  InAppPurchaseStarter
//
//  Created by Magdalena Toczek on 19/08/2020.
//  Copyright © 2020 Popeq Apps. All rights reserved.
//

//---------------------------------------------------------------------------------------------------------------------------------------------//
// must have a full developer account
// appstoreconnect.apple.com / itunesconnect.apple.com -> myApps -> plus -> new App -> name -> bundle
// provide app id for specific types of payment "bundle + name inAppPurchase" and save it in constants (productID)
// Features -> In-App Purchases -> plus -> choose type -> productID -> pice -> localization - possible translation into many languages -> SAVE
// My Apps -> Users and Roles -> Sandbox Testers -> plus -> fill in the data
// xCode : - capabilities - turn on in app purchase
// provide a button to restore status of payment (when user change phone, reinstall app)
//---------------------------------------------------------------------------------------------------------------------------------------------//




import Foundation
import StoreKit



class InAppPuchaseService: NSObject, SKPaymentTransactionObserver {
   

static let INSTANCE = InAppPuchaseService()

    
    
    func makePurchaseForItem(forProductId productID : String){
    
    if SKPaymentQueue.canMakePayments() {

        let payment = SKMutablePayment()
        payment.productIdentifier = productID
        SKPaymentQueue.default().add(payment)
    }
    else{
         print("User can't make payments")
    }
}
    
    
    
    func restore(){
      SKPaymentQueue.default().restoreCompletedTransactions()
        
      }

    
    
func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
  
    for transaction in transactions{
       switch transaction.transactionState{
          case .purchased:
                print("Transaction successful!")
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNotification(forStatus: .purchased, identifier: transaction.payment.productIdentifier)
                break
        
          case .restored:
                print("Transaction restored!")
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNotification(forStatus: .restored, identifier: transaction.payment.productIdentifier)
                break
        
          case .failed:
                print("Transaction failed!")
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNotification(forStatus: .failed, identifier: nil)
                break
        
          case .deferred:
            break
        
          case .purchasing:
            break
        
        default :
        break

        }
        }

      }
    

    //sending notification with status to vc => vc need observer
    func sendNotification(forStatus status: PurchaseStatus, identifier: String?){
        
        switch status{
        case .purchased:
            NotificationCenter.default.post(name: NSNotification.Name(notificationPurchaseFromInAppService), object: identifier)
            break
            
        case .restored:
            NotificationCenter.default.post(name: NSNotification.Name(notificationRestoreFromInAppService), object: identifier)
            break
            
        case .failed:
            NotificationCenter.default.post(name: NSNotification.Name(notificationFailureFromInAppService), object: nil)
            break

            
        }
    }
}

