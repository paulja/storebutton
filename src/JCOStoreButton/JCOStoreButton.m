//
//  JCOStoreButton.m
//
//  Created by Paul Jackson on 29/11/2015.
//  Copyright © 2015 Jaaco UK. All rights reserved.
//

#import "JCOStoreButton.h"

/*
 *  colours.
 */

static UIColor *kGreenColor = nil;


/*
 *  internal constants.
 */
static int kBorderWidth  = 1;
static int kCornerRadius = 3;


/*
 *  control class extentsion interface.
 */
@interface JCOStoreButton ()

/* label used to display price text */
@property (nonatomic, strong) UILabel   *priceLabel;
/* label used to display buy text */
@property (nonatomic, strong) UILabel   *buyLabel;
/* keeps track of view state to ensure efficient rendering */
@property (nonatomic, assign) BOOL      isValid;
/* tracks internal button state */
@property (nonatomic, assign) JCOStoreButtonState buttonState;

@end


/*
 *  control implementation.
 */
@implementation JCOStoreButton

#pragma mark - Init
#pragma mark -

+ (void)initialize {
    kGreenColor = [UIColor colorWithRed:0 green:0.56 blue:0 alpha:1];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self buttonInitialisation];
    }
    return self;
}

- (void)buttonInitialisation {
    /*
     *  initialise the internal layer.
     */
    CALayer *layer = self.layer;
    layer.borderWidth   = kBorderWidth;
    layer.cornerRadius  = kCornerRadius;
    layer.masksToBounds = YES;
    
    /*
     *  internal rendering state.
     */
    self.isValid = YES;
    
    /* 
     *  frame used by the labels.
     */
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    /*
     *  setup the price label.
     */
    self.priceLabel = [[UILabel alloc] initWithFrame:frame];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.font = self.titleLabel.font;
    [self addSubview:self.priceLabel];
    
    /*
     *  setup the buy label.
     */
    self.buyLabel = [[UILabel alloc] initWithFrame:frame];
    self.buyLabel.textAlignment = NSTextAlignmentCenter;
    self.buyLabel.font = self.titleLabel.font;
    [self addSubview:self.buyLabel];
    
    /*
     *  prevent external settings from breaking the control.
     */
    [self.titleLabel removeFromSuperview];
    self.backgroundColor = nil;
}

#pragma mark - Core overrides
#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /*
     *  early out if the internal state of the view is valid.
     */
    if (self.isValid) return;

    /*
     *  if the state of the view has not be rendered then set
     *  the correct state, then mark the view valid.
     */
    [self setButtonState:JCOStoreButtonStateNormal];
    self.isValid = YES;
}

#pragma mark - State management
#pragma mark -

- (void)applyNormalState {
    /*
     *  immediately hide the previous label control.
     */
    self.buyLabel.alpha = 0;

    /*
     *  animate the current label into view.
     */
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.borderColor = self.tintColor.CGColor;
        self.priceLabel.text = self.priceText;
        self.priceLabel.alpha = 1;

        [self applyNormalDefault];
    }];
    
    /*
     *  set the new state.
     */
    _buttonState = JCOStoreButtonStateNormal;
}

- (void)applyNormalDefault {
    self.priceLabel.backgroundColor = [UIColor clearColor];
    self.priceLabel.textColor = self.tintColor;
}

- (void)applyNormalSelected {
    self.priceLabel.backgroundColor = self.tintColor;
    self.priceLabel.textColor = [UIColor whiteColor];
}

- (void)applyBuyState {
    /*
     *  immediately hide the previous label control.
     */
    self.priceLabel.alpha = 0;

    /*
     *  animate the current label into view.
     */
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.borderColor = kGreenColor.CGColor;
        self.buyLabel.text = self.buyText;
        self.buyLabel.backgroundColor = [UIColor clearColor];
        self.buyLabel.alpha = 1;
        
        [self applyBuyDefault];

    }];
    
    /*
     *  set the new state.
     */
    _buttonState = JCOStoreButtonStateBuy;
}

- (void)applyBuyDefault {
    self.buyLabel.backgroundColor = [UIColor clearColor];
    self.buyLabel.textColor = kGreenColor;
}

- (void)applyBuySelected {
    self.buyLabel.backgroundColor = kGreenColor;
    self.buyLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Touch management
#pragma mark -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /*
     *  render the selected state.
     */
    switch (_buttonState) {
        case JCOStoreButtonStateNormal:
            [self applyNormalSelected];
            break;
        case JCOStoreButtonStateBuy:
            [self applyBuySelected];
            break;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    BOOL insideView  = CGRectContainsPoint(self.bounds, location);
    if (!insideView) {
        /*
         *  render the normal state without changing the control state.
         */
        switch (_buttonState) {
            case JCOStoreButtonStateNormal:
                [self applyNormalDefault];
                break;
            case JCOStoreButtonStateBuy:
                [self applyBuyDefault];
                break;
        }
    } else {
        /*
         *  render the next control state.
         */
        switch (self.buttonState) {
            case JCOStoreButtonStateNormal:
                [self applyBuyState];
                break;
            case JCOStoreButtonStateBuy:
                [self applyNormalState];
                break;
        }
        
        /*
         *  raise the touchUpInside event, as at the touch was inside
         *  the button.
         */
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Private
#pragma mark -

- (void)setButtonState:(JCOStoreButtonState)buttonState {
    switch (buttonState) {
        case JCOStoreButtonStateNormal:
            [self applyNormalState];
            break;
        case JCOStoreButtonStateBuy:
            [self applyBuyState];
            break;
    }
}

#pragma mark - Public
#pragma mark -

- (void)setPriceText:(NSString *)priceText {
    /*
     *  store the value.
     */
    _priceText = [priceText copy];

    /*
     *  mark the internal state of the view as invalid.
     */
    self.isValid = NO;
}

- (void)cancel {
    [self setButtonState:JCOStoreButtonStateNormal];
}

@end
