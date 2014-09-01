//
//  ViewController.m
//  iOSGetAddrFromdomain
//
//  Created by zk on 14-8-29.
//  Copyright (c) 2014年 zk. All rights reserved.
//

#import "ViewController.h"
#import "GetAddrObj.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GetAddrObj *getaddr = [[GetAddrObj alloc] init];
    NSString *str = [getaddr getaddr:@"lbs1.goolink.org" andport:12345];
    NSLog(@"str=%@",str);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
