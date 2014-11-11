//
//  InfoView.h
//  Confess
//
//  Created by Noga badhav on 09/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIViewController

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
- (IBAction)screenTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *firstInfo;
@property (weak, nonatomic) IBOutlet UILabel *secondInfo;
@property (weak, nonatomic) IBOutlet UILabel *thirdInfo;

@end
