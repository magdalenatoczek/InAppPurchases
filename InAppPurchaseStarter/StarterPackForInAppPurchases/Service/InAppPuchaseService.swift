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
//provide app id for specific types of payment "bundle + name inAppPurchase" and save it in constants (productID)
// Features -> In-App Purchases -> plus -> choose type -> productID -> pice -> localization - possible translation into many languages -> SAVE
// My Apps -> Users and Roles -> Sandbox Testers -> plus -> fill in the data
//xCode : - capabilities - turn on in app purchase
// provide a button to restore status of payment (when user change phone, reinstall app)
//---------------------------------------------------------------------------------------------------------------------------------------------//




import Foundation
import StoreKit

protocol InAppPuchaseServiceDelegate {
    func productLoaded()
}


class InAppPuchaseService: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
   

static let INSTANCE = InAppPuchaseService()
var productsIDs = Set<String>()
var productRequest = SKProductsRequest()
var products = [SKProduct]()
var delegate : InAppPuchaseServiceDelegate?


func loadProducts(){
  changeProductIDToStringSet()
  requestProducts(setOfString : productsIDs)
}


func changeProductIDToStringSet(){
  productsIDs.insert(FIRST_TYPE_PRODUCT_ID)
  productsIDs.insert(SECOND_TYPE_PRODUCT_ID)
}


func requestProducts(setOfString : Set<String>){
  productRequest.cancel()
    productRequest = SKProductsRequest(productIdentifiers : productsIDs)
  productRequest.delegate = self
  productRequest.start()
}


    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
    self.products = response.products

    if products.count == 0 {
      requestProducts(setOfString :productsIDs)
    } else{
      delegate?.productLoaded()

    }

}

func purchaseForItem(productIndex : ProductType){
    
    if SKPaymentQueue.canMakePayments() {
        
        
//    other way
//               let payment = SKMutablePayment()
//               payment.productIdentifier = (FIRST_TYPE_PRODUCT_ID)
//               SKPaymentQueue.default().add(payment)
        

            let product = products[productIndex.rawValue]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
    }
    else{
         print("User can't make payments")
    }


}



func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
  
    for transaction in transactions{
       switch transaction.transactionState{
          case .purchased:

                 print("Transaction successful!")
                 SKPaymentQueue.default().finishTransaction(transaction)
            break
          case .restored:
            break
          case .failed:
            break
          case .deferred:
            break
          case .purchasing:
            break
        default :
        print("fatal error")
        break
    
        
        }

}

    
      }

}

