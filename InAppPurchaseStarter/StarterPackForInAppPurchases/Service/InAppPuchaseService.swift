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



class InAppPuchaseService: SKReceiptRefreshRequest, SKPaymentTransactionObserver {
   

static let INSTANCE = InAppPuchaseService()
    

    var expirationDate = UserDefaults.standard.value(forKey: "expirationDate") as? Date


    override init(){
        super.init()
    }

    
    
    
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
    
    
 
    
    
    func requestDidFinish(_ request: SKRequest){
        uploadReceipt { (valid) in
            if valid{
                   //VALID
                self.isSubscriptionActive { active in
                    if active {
                        //ACTIVE
                        self.sendNotification(forStatus: .subscribed, identifier: nil, orsubscribeStatus: .active)
                        // subscription benefits on
                    }else{
                        //EXPIRED
                        self.sendNotification(forStatus: .subscribed, identifier: nil, orsubscribeStatus: .expired)
                        //lock out the subscription benefits
                    }
                }
            }else{
                //INVALID
                self.sendNotification(forStatus: .subscribed, identifier: nil, orsubscribeStatus: .inactive)
                    //lock out the subscription benefits
            }
        }
    }
 
    
    

    
    
func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
  
    for transaction in transactions{
       switch transaction.transactionState{
          case .purchased:
                print("Transaction successful!")
                    switch transaction.payment.productIdentifier {
                         case ProductType.exampleBuyConsumable.rawValue:
                            sendNotification(forStatus: .purchased, identifier: transaction.payment.productIdentifier, orsubscribeStatus: nil)
                            break
                        case ProductType.exampleBuyNonConsumable.rawValue:
                            sendNotification(forStatus: .purchased, identifier: transaction.payment.productIdentifier, orsubscribeStatus: nil)
                            break
                        case ProductType.exampleOfSubscription.rawValue:
                            sendNotification(forStatus: .purchased, identifier: transaction.payment.productIdentifier, orsubscribeStatus: .active)
                            break
                    default:
                        break
                }
                
                
             
                SKPaymentQueue.default().finishTransaction(transaction)
                break
        
          case .restored:
                print("Transaction restored!")
                sendNotification(forStatus: .restored, identifier: transaction.payment.productIdentifier, orsubscribeStatus: nil)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
        
          case .failed:
                print("Transaction failed!")
                sendNotification(forStatus: .failed, identifier: nil, orsubscribeStatus: nil)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
        
          case .deferred:
            sendNotification(forStatus: .failed, identifier: nil, orsubscribeStatus: nil)
                SKPaymentQueue.default().finishTransaction(transaction)
            break
        
          case .purchasing:
            break
        
        default :
        break

        }
        }

      }
    
    
    
    
  
    
  
    func sendNotification(forStatus status: PurchaseStatus, identifier: String?, orsubscribeStatus statusOfSubscription : SubscribeStatus?){
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
        case .subscribed:
            NotificationCenter.default.post(name: NSNotification.Name(notificationSubscribeChangeInAppService), object: statusOfSubscription)
            break
        }
    }
    

    
    func isSubscriptionActive(completionHandler: @escaping (Bool) -> Void){
        
        let nowDate = Date()
        expirationDate = UserDefaults.standard.value(forKey: "expirationDate") as? Date
        guard let expirationDate = expirationDate else {return}
        if nowDate.timeIntervalSince(expirationDate) < expirationDate.timeIntervalSinceNow {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }

    //PREVENT FROM STEALING checking if purchase is real
    func uploadReceipt(completionHandler: @escaping (Bool) -> Void){
        guard let receiptUrl = Bundle.main.appStoreReceiptURL, let receipt = try? Data(contentsOf: receiptUrl).base64EncodedString() else {
            completionHandler(false)
            return
        }
        let body = [
            "receipt-data": receipt,
            "password": " longStringGenereted"  //goto itunesConnect ->MyApps -> InAppPurchases -> Ap-Specific SharedSecret -> Generate -make a constant from it
        ]
        let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) {(responseData, response, error) in
            if let error = error {
                debugPrint(error)
                completionHandler(false)
                
            }else if let responseData = responseData {
                let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as! Dictionary <String,Any>
                //print(json)
                let newExpirationDate = self.expirationDate(jsonResponse: json)
                UserDefaults.standard.set(newExpirationDate, forKey: "expirationDate")
                completionHandler(true)
            }
        }
        task.resume()
    }

    func expirationDate(jsonResponse: Dictionary<String,Any>) -> Date?{
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            let lastReceipt = receiptInfo.lastObject as! Dictionary<String, Any>
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:dd VV"
            let expiesDataAsString = lastReceipt["expires_date"] as! String
            let expirationDate: Date = formatter.date(from: expiesDataAsString)!
            return expirationDate
        }else{
            return nil
        }
    }
    
    
     func restore(){
        SKPaymentQueue.default().restoreCompletedTransactions()
       }
}

