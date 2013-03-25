//
//  ViewController.m
//  ScanExample
//
//  Created by Kevin Rohling on 5/16/12.
//  Copyright (c) 2012 card.io. All rights reserved.
//

#import "ViewController.h"

#import "Constants.h"
#import "CardIO.h"

@interface ViewController () <CardIOPaymentViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.text = @"";
}

#pragma mark - User Actions
#pragma mark -

- (void)scanCardClicked:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    scanViewController.appToken = CardIOAppToken; // see Constants.h
    [self presentViewController:scanViewController animated:TRUE completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate
#pragma mark -

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
    self.infoLabel.text = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
