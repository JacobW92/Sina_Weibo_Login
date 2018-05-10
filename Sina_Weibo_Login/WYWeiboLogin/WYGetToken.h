//
//  WYGetToken.h
//  Sina_Weibo_Login
//
//  Created by Jacob on 2018/5/11.
//  Copyright © 2018 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kAppKey = @"AppKey";
static NSString *kAppSec = @"AppSec";
static NSString *kRedUrl = @"http://www.baidu.com";
static NSString *sinaWeiboPublicKey = @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrKjhWhmGIf6GAvdtcq9XyHHv9WcCQyy0kWoesJTBiiCcpKT5VBjUFCOf5qju3f0MzIxSQ+RX21jxV/i8IpJs1P0RK05k8rMAtt4Sru45CqbG7//s4vhjXjoeg5Bubj3OpKO4MzuH2c5iEuXd+T+noihu+SVknrEp5mzGB1kQkQwIDAQAB-----END PUBLIC KEY-----";

typedef enum {
    AFNRJSON,
    AFNRHTTP,
    AFNRHTTPCODE,
} AFNSerializer;



@interface WYGetToken : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *pwdHex;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSDictionary *preloginDat;
@property (nonatomic, copy) NSString *sDat;
@property (nonatomic, strong) NSDictionary *form;
@property (nonatomic, assign) BOOL isSucced;
@property (nonatomic, strong) NSString *ticket;
@property (nonatomic, strong) NSString *codeUrl;
@property (nonatomic, strong) NSString *codeDat;
@property (nonatomic, strong) NSString *token;
- (id)initWithUsername:(NSString *)un password:(NSString *)pwd;
- (void)getTokenDic;


@end

