//
//  ConfessWrite.h
//  Confess
//
//  Created by Noga badhav on 09/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfessView.h"

@interface ConfessWrite : UIViewController

- (IBAction)confessClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confessButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
- (IBAction)closeClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (strong, nonatomic) IBOutlet NSString *name;
-(void)initProperties : (NSString*) pName : (ConfessView*) view;
@property (weak, nonatomic) IBOutlet UILabel *initailText;
@property (weak, nonatomic) IBOutlet UIButton *closeButto;
@property (weak, nonatomic) IBOutlet ConfessView *confessView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe;
- (IBAction)swipedAction:(id)sender;
- (IBAction)leftSwipedAction:(id)sender;

@end
