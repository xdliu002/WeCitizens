//
//  ReplyModel.swift
//  WeCitizens
//
//  Created by Teng on 3/27/16.
//  Copyright © 2016 Tongji Apple Club. All rights reserved.
//

import Foundation
import Parse

class ReplyModel: DataModel {
    //获取指定数量reply,code completed
    func getReply(queryNum:Int, queryTimes:Int, cityName:String, resultHandler: ([Reply]?, NSError?) -> Void) {
        let query = PFQuery(className: "Reply")
        
        query.whereKey("city", equalTo: cityName)
        query.limit = queryNum
        query.skip = queryNum * queryTimes
        
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if nil == error {
                print("Successfully retrieved \(results!.count) replies.")
                
                if let objects = results {
                    var replies = [Reply]()
                    
                    for result in objects {
                        let email = result.objectForKey("userEmail") as! String
                        let name = result.objectForKey("userName") as! String
                        
                        let title = result.objectForKey("title") as! String
                        let time = result.createdAt!
                        let id = result.objectForKey("voiceId") as! String
                        let city = result.objectForKey("city") as! String
                        let content = result.objectForKey("content") as! String
                        
                        let satisfyDictionary = result.objectForKey("satisfyLevel") as! NSDictionary
                        let level1 = satisfyDictionary.valueForKey("level1") as! Int
                        let level2 = satisfyDictionary.valueForKey("level2") as! Int
                        let level3 = satisfyDictionary.valueForKey("level3") as! Int
                        let level4 = satisfyDictionary.valueForKey("level4") as! Int
                        let satisfy = Satisfy(num1: level1, num2: level2, num3: level3, num4: level4)
                        
                        let images = result.objectForKey("images") as! NSArray
                        let imageList = super.convertArrayToImages(images)
                        
                        let newReply = Reply(emailFromRemote: email, name: name, title: title, date: time, voiceId: id, content: content, city: city, satisfyLevel: satisfy, images: imageList)
                        
                        replies.append(newReply)
                    }
                    resultHandler(replies, nil)
                } else {
                    //Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                    resultHandler(nil, error)
                }
            }
        }
    }
    
    //用户对reply投票
    func addSatisfication(replyId:String, attitude:Int, resultHandler: (Bool, NSError?) -> Void) {
        let query = PFQuery(className: "Reply")
        
        query.whereKey("objectId", equalTo: replyId)
        
        do {
            let result = try query.getFirstObject()
            
            let currentLevel = result.valueForKey("satisfyLevel") as! NSDictionary
            var current:Int
            switch (attitude) {
            case 1:
                current = currentLevel.valueForKey("level1") as! Int
                current++
                currentLevel.setValue(current, forKey: "level1")
            case 2:
                current = currentLevel.valueForKey("level2") as! Int
                current++
                currentLevel.setValue(current, forKey: "level2")
            case 3:
                current = currentLevel.valueForKey("level3") as! Int
                current++
                currentLevel.setValue(current, forKey: "level3")
            case 4:
                current = currentLevel.valueForKey("level4") as! Int
                current++
                currentLevel.setValue(current, forKey: "level4")
            default:
                print("")
            }
            result.setValue(currentLevel, forKey: "satisfyLevel")
            result.saveInBackgroundWithBlock(resultHandler)
        } catch {
            print("Add satisfy error!!!!!!!!")
            resultHandler(false, nil)
        }
    }
    
    //还需要为Voice填上replyId，未完成
    func addNewReply(newReply: Reply, resultHandler: (Bool, NSError?) -> Void) {
        let reply = PFObject(className: "Reply")
        
        reply["userEmail"] = newReply.userEmail
        reply["userName"] = newReply.userName
        reply["voiceId"] = newReply.voiceId
        reply["city"] = newReply.city
        reply["title"] = newReply.title
        reply["content"] = newReply.content
        reply["satisfyLevel"] = newReply.satisfyDictionary
        reply["images"] = super.convertImageToPFFile(newReply.images)
        
        reply.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                resultHandler(success, nil)
            } else {
                //Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                resultHandler(false, error)
            }
        }
    }
    
    //根据replyID获取reply
    func getReply(replyId:String, resultHandler: (Reply?, NSError?) -> Void) {
        let query = PFQuery(className: "Reply")
        
        query.getObjectInBackgroundWithId(replyId) { (object, error) -> Void in
            if nil == error {
                if let result = object {
                    let email = result.objectForKey("userEmail") as! String
                    let name = result.objectForKey("userName") as! String
                    
                    let title = result.objectForKey("title") as! String
                    let time = result.createdAt!
                    let id = result.objectForKey("voiceId") as! String
                    let city = result.objectForKey("city") as! String
                    let content = result.objectForKey("content") as! String
                    
                    let satisfyDictionary = result.objectForKey("satisfyLevel") as! NSDictionary
                    let level1 = satisfyDictionary.valueForKey("level1") as! Int
                    let level2 = satisfyDictionary.valueForKey("level2") as! Int
                    let level3 = satisfyDictionary.valueForKey("level3") as! Int
                    let level4 = satisfyDictionary.valueForKey("level4") as! Int
                    let satisfy = Satisfy(num1: level1, num2: level2, num3: level3, num4: level4)
                    
                    let images = result.objectForKey("images") as! NSArray
                    let imageList = super.convertArrayToImages(images)
                    
                    let newReply = Reply(emailFromRemote: email, name: name, title: title, date: time, voiceId: id, content: content, city: city, satisfyLevel: satisfy, images: imageList)
                    
                    resultHandler(newReply, nil)
                } else {
                    resultHandler(nil, nil)
                }
            } else {
                resultHandler(nil, error)
            }
            
        }
    }


}