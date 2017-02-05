//
//  TouchIdHandler.swift
//  TouchIdWrapper
//
//  Created by Manish Kumar on 2/5/17.
//  Copyright © 2017 Manish Kumar. All rights reserved.
//

/*
 @Implementation Note:
 Touch Id based login works in cunjunction of three layers:
 1.App Layer - Application prompt for touch id using local authentication framework.
 2.Keychain Wrapper - This is Apple class provided for handling data storage in keychain.Developer will use
   this class for storing either username and password || refresh token for making login service calls or any other service 
   call.It Primarily Using Four methods:
    SecItemCopyMatching
    SecItemAdd
    SecItemUpdate
    SecItemDelete
 
 3.Service Layer - App Needs services which will be called if user gets authenticated using touch id
 
 @Release Notes - Notification Will be used for handling UI releated stuffs
 */


import UIKit
import LocalAuthentication

private let NOTIFICATION_TOUCH_ID_DEVICE_STATUS = "TouchControlStateChanged"

class TouchIdHandler: NSObject {
    static let sharedInstance = TouchIdHandler()
    static var touchReasonString = "Please place your finger on the sensor so we can authenticate you"
    private override init() {
        
    }
    /*
     @func :authenticateViaTouchID
     @desc : This method enables user to get authenticated using touch id.App can use notification as observer 
     for getting current touch id status to show user about current status
     */
    func authenticateViaTouchID() {
        // Create the Local Authentication Context
        let touchIDContext = LAContext()
        var touchIDError : NSError?
        // Check if we can access local device authentication
        if touchIDContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error:&touchIDError) {
            print("User can use touch id")
            // Check current authentication response
            touchIDContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: TouchIdHandler.touchReasonString, reply: {(suceess,error) in
                if suceess {
                    // User authenticated using Local Device Authentication Successfully!
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_TOUCH_ID_DEVICE_STATUS), object: error)
                }
                else{
                    //Got Run Time Error - > UI Need to be updated
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_TOUCH_ID_DEVICE_STATUS), object: error)
                    print("Check error description --%@ with code ::%d",error.debugDescription,error?._code ?? -2222)
                }
            })
        } else {
            //This is probably an older device, older than an iPhone 5s
            print("User cannnot use touch id for login :: error description --%@ with code ::%d",touchIDError.debugDescription,touchIDError?._code ?? -2225)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_TOUCH_ID_DEVICE_STATUS), object: touchIDError)
        }
}
    func enableTouchIdFromServer() -> Bool{
        //MARK: MAKE Service Call on Sucessfull authetication for enabling touch based login
        return true
    }
    func disableTouchIdForUser() ->Bool{
        //MARK: MAKE Service Call If User change their preference for touch based login
        return true
    }
    func addTokenAtKeychain() -> Bool{
        //MARK: Store Token In Keychain From enableTouchIdFromService web service response
        return true
    }
    func removeTokenFromKeychain() -> Bool{
        //MARK: Remove keychain if disableTouchIdForUser service call is successful
        return true
    }
    func fetchRefreshTokenFromKeychain() -> String{
       //MARK: Get refresh token from keychain if this is required for login through touch
        return "refresh_Token"
    }
}
