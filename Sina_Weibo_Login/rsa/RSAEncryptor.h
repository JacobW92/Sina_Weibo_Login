//
//  RSAEncryptor.h
//  Sina_Weibo_Login
//
//  Created by Jacob on 2018/5/11.
//  Copyright © 2018 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject

+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

+ (SecKeyRef)addPublicKey:(NSString *)key;



@end
