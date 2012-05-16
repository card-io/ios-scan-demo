//
//  ViewController.m
//  ScanExample
//
//  Created by Kevin Rohling on 5/16/12.
//  Copyright (c) 2012 card.io. All rights reserved.
//

#import "ViewController.h"
#import "CardIOChargeRequest.h"
#import "CardIOPaymentViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

- (void) scanCardClicked:(id)sender {
  // This list of items probably comes from elsewhere, but let's hard-code it, by way of example.
  // IMPORTANT: All amounts are in *cents*
  NSArray *itemsToBuy = [NSArray arrayWithObjects:
                         [CardIOChargeRequest itemWithDescription:@"Stuffed puffin" amount:1500],
                         [CardIOChargeRequest itemWithDescription:@"Puffin hat" amount:500],
                         nil];
  
  // Each item must have a description, and the items must total to at least 100 ($1 USD) and at most 100000 ($1000 USD).
  
  // create a CardIOChargeRequest
  CardIOChargeRequest *chargeRequest = [[CardIOChargeRequest alloc] init];
  chargeRequest.appToken = @"YOUR_APP_TOKEN_HERE"; // get your app token from the card.io website
  chargeRequest.currency = @"USD"; // must be @"USD"
  chargeRequest.items = itemsToBuy;
  
  // chargeRequest.live = YES; // uncomment for "live" charges (i.e real money will change hands)
  
  // Double-check request validity. If the request is not valid, we'll end up with a nil
  // view controller, which throws an exception if presented.
  NSError *requestError = nil;
  BOOL requestIsValid = [chargeRequest isValid:&requestError];
  if(requestIsValid) {
    CardIOPaymentViewController *charger = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self
                                                                                          chargeRequest:chargeRequest];
    [self presentModalViewController:charger animated:YES];
  } else {
    // Oops! An item must be missing a description, or the amounts must not total to an allowable amount.
    // Let the user know here, or log/inspect requestError, or fix the problem...
  }
}

#pragma mark - CardIOPaymentViewControllerDelegate model methods

- (void)paymentViewController:(CardIOPaymentViewController *)paymentViewController
       didSucceedWithResponse:(CardIOChargeResponse *)response {
  
  NSLog(@"Charge succeeded with response: %@", response);
  // Do whatever needs to be done to deliver the purchased items.
}

- (void)paymentViewController:(CardIOPaymentViewController *)paymentViewController
             didFailWithError:(NSError *)error {
  
  // Charge failed...don't deliver anything.
  // This should *rarely* happen. Most times, when something goes wrong, card.io
  // will handle the error internally and communicate with the user. This is for
  // exceptional circumstances, such as an invalid or disabled app token.
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                  message:@"Unable to complete purchase"
                                                 delegate:nil
                                        cancelButtonTitle:@"Ok"
                                        otherButtonTitles:nil];
  [alert show];
  NSLog(@"Error in payment: %@", error);
}

#pragma mark - CardIOPaymentViewControllerDelegate UI methods

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  NSLog(@"User cancelled payment");
  [self dismissModalViewControllerAnimated:YES];
}

- (void)paymentViewControllerDidFinish:(CardIOPaymentViewController *)paymentViewController {
  NSLog(@"Payment view controller finished.");
  [self dismissModalViewControllerAnimated:YES];
}

@end
