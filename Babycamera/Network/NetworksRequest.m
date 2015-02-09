//
//  NetworksRequest.m
//  Babycamera
//
//  Created by bear on 15/1/23.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "NetworksRequest.h"
#import "AFNetworking.h"
#import "Macro.h"

@implementation NetworksRequest

//同步

+ (id)syncRequestCommand:(commandType)command
                 andUserID:(NSString*)uid
         andNeedBobyArrKey:(NSArray*)bobyArrkey
       andNeedBobyArrValue:(NSArray*)bobyArrValue
{
    
    //请求头
    NSMutableArray *headKey = [NSMutableArray arrayWithObjects:@"flag" , @"sequence" , @"timestamp" , @"command" , @"uid" ,nil] ;
    NSNumber *commandStr = [NSNumber numberWithInteger:command];
    NSMutableArray *headValue = [NSMutableArray arrayWithObjects:@"0"  , @"0" , @"0", commandStr , uid , nil] ;
    
    NSMutableDictionary *headDic =[NSMutableDictionary dictionaryWithObjects:headValue forKeys:headKey];
    
    //请求体、把请求体的headKey和headValue装进字典里
    NSMutableDictionary *bobyDic =[NSMutableDictionary dictionaryWithObjects:bobyArrValue forKeys:bobyArrkey];
    
    //把请求体与 请求头装进字典里
    NSMutableDictionary *requestDict =[[NSMutableDictionary alloc]init];
    [requestDict setObject:headDic forKey:@"message_head"] ;
    [requestDict setObject:bobyDic forKey:@"message_body"] ;
    
    // 初始化請求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:REQUSET_URL]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60.0];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:nil]];
    // 发送同步请求
    NSError *error = nil ;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:&error];
   
    if (error ) {
        return error ;
    }
    else{
        NSError *error = nil ;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
             return json ;
        }
        return nil ;
    }
    
    return nil ;
}

//异步
+ (void)requestWithCommand:(commandType)command
         andNeedUserId:(NSString*)userId
     AndNeedBobyArrKey:(NSArray*)bobyArrkey
   andNeedBobyArrValue:(NSArray*)bobyArrValue
         completeBlock:(completion)completionblock
          netFailBlock:(netfailed)netFailBlock
{
    
    //请求头
    NSMutableArray *headKey = [NSMutableArray arrayWithObjects:@"flag" , @"sequence" , @"timestamp" , @"command" , @"uid" ,nil] ;
    NSNumber *commandStr = [NSNumber numberWithInteger:command];
    NSMutableArray *headValue = [NSMutableArray arrayWithObjects:@"0"  , @"0" , @"0", commandStr , userId , nil] ;
    
    NSMutableDictionary *headDic =[NSMutableDictionary dictionaryWithObjects:headValue forKeys:headKey];
    
    //请求体、把请求体的headKey和headValue装进字典里
    NSMutableDictionary *bobyDic =[NSMutableDictionary dictionaryWithObjects:bobyArrValue forKeys:bobyArrkey];
    
    //把请求体与 请求头装进字典里
    NSMutableDictionary *requestDict =[[NSMutableDictionary alloc]init];
    [requestDict setObject:headDic forKey:@"message_head"] ;
    [requestDict setObject:bobyDic forKey:@"message_body"] ;
    
    //post
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager POST:REQUSET_URL parameters:requestDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self analyticalDataAction:responseObject andCompleteBlock:completionblock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (netFailBlock) {
            netFailBlock(error);
        }
        
    }];
   
}
//解析
+ (void)analyticalDataAction:(id)soucresData andCompleteBlock:(completion)completionBlock
{
    
    if (![soucresData isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    
    NSDictionary *dict = (NSDictionary*)soucresData ;
    NSInteger commandInt = [dict[@"message_head"][@"command"] integerValue] & 0x7FFFFFFF ;
    NSInteger errorInt = [dict[@"message_body"][@"error"] integerValue];
    
    if (commandInt == RegisterCommand)
    {
        if (completionBlock)
        {
            NSArray *arr  = @[[NSString stringWithFormat:@"%d" , commandInt] , [NSString stringWithFormat:@"%d" , errorInt]];
            completionBlock(arr);
        }
    }
    else if (commandInt == loginCommand)
    {
        NSString *uid = dict[@"message_head"][@"uid"];
        if (completionBlock)
        {
            NSArray *arr  = @[[NSString stringWithFormat:@"%d" , commandInt] , [NSString stringWithFormat:@"%d" , errorInt] , uid];
            completionBlock(arr);
        }
    }
    else if (commandInt == SignOutCommand)
    {
        if (completionBlock)
        {
            NSArray *arr  = @[[NSString stringWithFormat:@"%d" , commandInt] , [NSString stringWithFormat:@"%d" , errorInt]];
            completionBlock(arr);
        }
    }
    else if (commandInt == RequestVcodeCommand)
    {
        
        if (completionBlock )
        {
            NSArray *arr  = @[[NSString stringWithFormat:@"%d" , commandInt] , [NSString stringWithFormat:@"%d" , errorInt]];
            completionBlock(arr);
        }
    }
    else if (commandInt == SubmitVcodeCommand)
    {
        if (completionBlock )
        {
            NSArray *arr  = @[[NSString stringWithFormat:@"%d" , commandInt] , [NSString stringWithFormat:@"%d" , errorInt]];
            completionBlock(arr);
        }
    }
}
@end
