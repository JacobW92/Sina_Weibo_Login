//
//  ViewController.m
//  Sina_Weibo_Login
//
//  Created by Jacob on 2018/5/10.
//  Copyright © 2018 Jacob. All rights reserved.
//

#import "ViewController.h"
#import "WYGetToken.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[[WYGetToken alloc] initWithUsername:@"username" password:@"password"] getTokenDic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
