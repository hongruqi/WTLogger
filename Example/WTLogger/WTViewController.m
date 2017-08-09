//
//  WTViewController.m
//  WTLogger
//
//  Created by lbrsilva-allin on 08/09/2017.
//  Copyright (c) 2017 lbrsilva-allin. All rights reserved.
//

#import "WTViewController.h"
#import "WTLogger.h"

@interface WTViewController ()

@end

@implementation WTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [WTLogger shareInstance];
    for (int i = 0 ; i < 100; i++) {
       [WTLogger event:@"qqqqq" attributes:@{@"qq":@"aaaaa"}];
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
