//
//  JCOStoreButton.h
//
//  Created by Paul Jackson on 29/11/2015.
//  Copyright © 2015 Jaaco UK. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  button states.
 */
typedef enum : NSUInteger {
    JCOStoreButtonStateNormal = 1 << 1,
    JCOStoreButtonStateBuy    = 1 << 2,
} JCOStoreButtonState;


@interface JCOStoreButton : UIButton

/*
 *  text to render modelling the price.
 */
@property (nonatomic, strong) NSString *priceText;

/*  
 *  text to render modelling the call to action text.
 */
@property (nonatomic, strong) NSString *buyText;

/* 
 * gets the current button state.
 */
@property (nonatomic, readonly) JCOStoreButtonState buttonState;

/*
 *  cancels the button, and restores to the initial state.
 */
- (void)cancel;

@end