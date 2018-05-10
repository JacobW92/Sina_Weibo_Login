//
//  NSString+Base64.h
//  Sina_Weibo_Login
//
//  Created by Jacob on 2018/5/11.
//  Copyright © 2018 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

- (NSString *)hexStringFromString:(NSString *)string;

- (NSString *)NSStringToBase64Encoded;

- (NSString *)base64DecodedToNSString;

@end
