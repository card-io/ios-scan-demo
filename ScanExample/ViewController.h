//
//  ViewController.h
//  ScanExample
//
//  Created by Kevin Rohling on 5/16/12.
//  Copyright (c) 2012 card.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"

@interface ViewController : UIViewController <CardIOPaymentViewControllerDelegate>

- (IBAction)scanCardClicked:(id)sender;

@end