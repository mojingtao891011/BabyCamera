//
//  NetworksRequest.h
//  Babycamera
//
//  Created by bear on 15/1/23.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum :NSInteger
{
    
    RegisterCommand = 725 ,
    loginCommand = 726 ,
    SignOutCommand = 727 ,
    RequestVcodeCommand = 761 ,
    SubmitVcodeCommand = 762
    
}commandType;

typedef void(^completion)(id);
typedef void(^netfailed)(id);

@interface NetworksRequest : NSObject


//同步
+ (id)syncRequestCommand:(commandType)command
                 andUserID:(NSString*)uid
         andNeedBobyArrKey:(NSArray*)bobyArrkey
       andNeedBobyArrValue:(NSArray*)bobyArrValue;

//异步
+ (void)requestWithCommand:(commandType)command
             andNeedUserId:(NSString*)userId
         AndNeedBobyArrKey:(NSArray*)bobyArrkey
       andNeedBobyArrValue:(NSArray*)bobyArrValue
             completeBlock:(completion)completionblock
              netFailBlock:(netfailed)netFailBlock ;

@end
