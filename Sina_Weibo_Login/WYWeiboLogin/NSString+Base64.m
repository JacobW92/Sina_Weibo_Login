//
//  NSString+Base64.m
//  Sina_Weibo_Login
//
//  Created by Jacob on 2018/5/11.
//  Copyright © 2018 Jacob. All rights reserved.
//

#import "NSString+Base64.h"


@implementation NSString (Base64)

- (NSString *)NSStringToBase64Encoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedToNSString {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if ([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

- (NSString *)getHEX:(NSData *)data
{
    const unsigned char *dataBytes = [data bytes];
    NSMutableString *ret = [NSMutableString stringWithCapacity:[data length] * 2];
    for (int i=0; i<[data length]; ++i)
        [ret appendFormat:@"%02X", (unsigned int)dataBytes[i]];//NSUInteger
    return ret;
    
}


@end
