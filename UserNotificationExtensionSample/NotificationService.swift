//
//  NotificationService.swift
//  UserNotificationExtensionSample
//
//  Created by Kentaro Matsumae on 2016/07/22.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler:(UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return
        }
    
        guard let url = (bestAttemptContent.userInfo["img_url"] as? String).flatMap({ URL(string: $0) }) else {
            contentHandler(bestAttemptContent)
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.downloadTask(with: url, completionHandler: { (location, reponse, err) in
            if err != nil {
                print(err)
                contentHandler(bestAttemptContent)
                return
            }
            guard let localtion = location else {
                contentHandler(bestAttemptContent)
                return
            }
            
            do {
                var copiedLocation = localtion
                try copiedLocation.appendPathExtension(".png")
                try FileManager.default.copyItem(at: localtion, to: copiedLocation)

                let att = try UNNotificationAttachment(identifier: "image", url: copiedLocation, options: nil)
                bestAttemptContent.attachments = [att]
                contentHandler(bestAttemptContent)
                
            } catch (let exception) {
                print(exception)
                contentHandler(bestAttemptContent)
                return
            }
        })
        task.resume()
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
