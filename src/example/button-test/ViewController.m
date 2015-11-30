//
//  ViewController.m
//  button-test
//
//  Created by Paul Jackson on 29/11/2015.
//  Copyright © 2015 Jacco UK. All rights reserved.
//

#import "ViewController.h"
#import "JCOStoreButton.h"

@interface ViewController ()

- (IBAction)touch:(JCOStoreButton *)sender;

@end

@implementation ViewController

- (IBAction)touch:(JCOStoreButton *)sender {
    /*
     *  if the state of the control AFTER being touched is 
     *  `normal` then that means is was `buy` before that,
     *  therefore they want to buy this one. This should 
     *  probably transition to downloading/purchasing or 
     *  something in future releases.
     */
    if (sender.buttonState == JCOStoreButtonStateNormal) {
        /*
         *  construct display message.
         */
        NSString *message =
            [NSString stringWithFormat:@"BUY %@", sender.priceText];

        /*
         *  create alert.
         */
        UIAlertController *alert =
            [UIAlertController
                 alertControllerWithTitle:@"Purchase"
                 message:message
                 preferredStyle:UIAlertControllerStyleAlert];
        
        /*
         *  create cancel/close action.
         */
        [alert addAction:
            [UIAlertAction
                 actionWithTitle:@"Close"
                 style:UIAlertActionStyleCancel
                 handler:nil]];
        
        /*
         *  display message.
         */
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        /*
         *  enumerable the subviews, cancelling any other
         *  store buttons.
         */
        NSArray *subviews = self.view.subviews;
        [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            /*
             *  ignore touched button.
             */
            if (obj == sender) return;

            /*
             *  ignore otherviews.
             */
            if ([obj class] != [JCOStoreButton class]) return;
            
            /*
             *  cancel.
             */
            [(JCOStoreButton *)obj cancel];
        }];
    }
}

@end