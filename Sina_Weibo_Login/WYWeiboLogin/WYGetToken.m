//
//  WYGetToken.m
//  Sina_Weibo_Login
//
//  Created by Jacob on 2018/5/11.
//  Copyright © 2018 Jacob. All rights reserved.
//


#import "WYGetToken.h"
#import "NSString+Base64.h"
#import "RSAEncryptor.h"

#import <AFNetworking/AFNetworking.h>



@implementation WYGetToken

- (id)initWithUsername:(NSString *)un password:(NSString *)pwd {
    if(self = [super init]) {
        self.username = un;
        self.password = pwd;
        self.dict = @{@"entry": @"openapi",@"gateway": @"1",@"from": @"",@"savestate": @"0",@"userticket": @"1",@"pagerefer": @"",@"ct": @"1800",@"s": @"1",@"vsnf": @"1",@"vsnval": @"",@"door": @"",@"appkey": @"",@"returntype": @"TEXT",@"su": @"",@"service": @"miniblog",@"servertime": @"",@"nonce": @"",@"pwencode": @"rsa2",@"rsakv": @"1330428213",@"sp": @"",@"sr": @"1280*720",@"encoding": @"UTF-8",@"cdult": @"2",@"prelt": @"31",@"domain": @"weibo.com",};
        self.form = @{@"action": @"login",@"display": @"default",@"withOfficalFlag": @"0",@"quick_auth": @"null",@"withOfficalAccount": @"",@"scope": @"",@"ticket": @"",@"isLoginSina": @"",@"response_type": @"code",@"regCallback": @"",@"redirect_uri": kRedUrl,@"client_id": kAppKey,@"appkey62": @"52laFx",@"state": @"",@"verifyToken": @"null",@"from": @"",@"switchLogin": @"0",@"userId": @"",@"passwd": @"",};
    }
    return self;
}

- (AFHTTPSessionManager *)shareManagerWithType:(AFNSerializer)type {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain", nil];
    if (type == AFNRJSON) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain", nil];
    } else if (type == AFNRHTTPCODE) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:@"https://api.weibo.com/oauth2/default.html" forHTTPHeaderField:@"Referer"];
    } else {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return manager;
}


- (void)getPreloginDataNumberOfTimes:(NSUInteger)ntimes
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure {
    NSString *purl = @"https://login.sina.com.cn/sso/prelogin.php";
    NSDictionary *ppara = @{@"entry": @"openapi",@"callback": @"sinaSSOController.preloginCallBack",@"su": [self.username NSStringToBase64Encoded],@"rsakt": @"mod",@"checkpin": @"1",@"client": @"ssologin.js(v1.4.18)",};
    if (ntimes <= 0) {
        if (failure) {
            NSError *error = nil;
            failure(error);
        }
    } else {
        [[self shareManagerWithType:AFNRHTTP] GET:purl parameters:ppara progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *s = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] copy];
            NSString *json = [self needToRegular:s regular:@"\\((.*)\\)" location:1 length:-2];
            self.preloginDat = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self getPreloginDataNumberOfTimes:ntimes - 1 success:success failure:failure];
        }];
    }
}

- (void)getPreloginDataFromStr {
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"\\((.*)\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *res = [[re matchesInString:self.sDat options:0 range:NSMakeRange(0, [self.sDat length])] objectAtIndex:0];
    NSRange range = res.range;
    range.location++;
    range.length = range.length - 2;
    NSString *s = [self.sDat substringWithRange:range];
    NSError *err = nil;
    self.preloginDat = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
}

- (void)setPreloginDat:(NSDictionary *)preloginDat {
    _preloginDat = preloginDat;
    [self getTicketData];
}

- (void)getTicketData {
    NSString *ticketUrl = @"https://login.sina.com.cn/sso/login.php?client=ssologin.js(v1.4.18)";
    NSMutableDictionary *f = [[NSMutableDictionary alloc] initWithDictionary:[self.dict copy]];
    f[@"servertime"] = self.preloginDat[@"servertime"];
    f[@"nonce"] = self.preloginDat[@"nonce"];
    f[@"su"] = [self.username NSStringToBase64Encoded];
    [self rsaEncryptByPublicKeyWith:f[@"servertime"] nonce:f[@"nonce"]];
    f[@"sp"] = self.pwdHex;
    f[@"rsakv"] = self.preloginDat[@"rsakv"];
    [[self shareManagerWithType:AFNRJSON] POST:ticketUrl parameters:f progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tk = (NSDictionary *)responseObject;
        self.ticket = tk[@"ticket"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error to get ticket!!!");
        NSLog(@"%@", error);
    }];
}

- (void)setTicket:(NSString *)ticket {
    _ticket = ticket;
    [self getCodeData];
}

- (void)getCodeData {
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] initWithDictionary:[self.form copy]];
    NSString *authUrl = @"https://api.weibo.com/oauth2/authorize";
    fields[@"ticket"] = self.ticket;
    NSString *rCallback = [[NSString alloc] initWithFormat:@"https://api.weibo.com/2/oauth2/authorize?client_id=%@&response_type=code&display=default&redirect_uri=%@&from=&with_cookie=", kAppKey, kRedUrl];
    fields[@"regCallback"] = rCallback;
    [[self shareManagerWithType:AFNRHTTPCODE] POST:authUrl parameters:fields progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *codeUrl = [task.currentRequest.URL absoluteString];
        self.codeDat = [self needToRegular:codeUrl regular:@"(\\w{32})" location:0 length:0];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error to get Code!!!!");
        NSLog(@"%@", error);
    }];
    
}

- (NSString *)needToRegular:(NSString *)String
                    regular:(NSString *)r
                   location:(NSInteger)location
                     length:(NSInteger)length {
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:r options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *res = [[re matchesInString:String options:0 range:NSMakeRange(0, [String length])] objectAtIndex:0];
    NSRange range = res.range;
    if(location != 0) {
        range.location = range.location + location;
    }
    if(location != 0) {
        range.length = range.length + length;
    }
    NSString *str = [String substringWithRange:range];
    return str;
}


- (void)getTokenDic {
    [self getPreloginDataNumberOfTimes:5 success:^(id responseObject) {
        NSLog(@"Success to get Token!");
    } failure:^(NSError *error) {
        NSLog(@"Error!!!!");
    }];
}


-(void)rsaEncryptByPublicKeyWith:(NSString *)servertime
                           nonce:(NSString *)nonce {
    NSString *message = [[NSString alloc] initWithFormat:@"%@\t%@\n%@", servertime, nonce, self.password];
    self.pwdHex = [RSAEncryptor encryptString:message publicKey:sinaWeiboPublicKey];
}

- (void)setCodeDat:(NSString *)codeDat {
    _codeDat = codeDat;
    [self getTokenDat];
}

- (void)getTokenDat {
    NSDictionary *tData = @{@"client_id": kAppKey,@"client_secret": kAppSec,@"grant_type": @"authorization_code",@"code": self.codeDat,@"redirect_uri": kRedUrl,};
    NSString *tokenUrl = @"https://api.weibo.com/oauth2/access_token";
    [[self shareManagerWithType:AFNRJSON] POST:tokenUrl parameters:tData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *t = (NSDictionary *)responseObject;
        self.token = t[@"access_token"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error to get Token!!!!!");
        NSLog(@"%@", error);
    }];
}

- (void)setToken:(NSString *)token {
    _token = token;
    NSLog(@"%@", token);
}

@end

