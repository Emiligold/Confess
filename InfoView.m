//
//  InfoView.m
//  Confess
//
//  Created by Noga badhav on 09/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "InfoView.h"

@interface InfoView ()

@end

@implementation InfoView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableParagraphStyle *styleFirst  = [[NSMutableParagraphStyle alloc] init];
    styleFirst.minimumLineHeight = 32.f;
    styleFirst.maximumLineHeight = 32.f;
    NSDictionary *attributtesFirst = @{NSParagraphStyleAttributeName : styleFirst,};
    self.firstInfo.attributedText = [[NSAttributedString alloc] initWithString:@"Your friend can not know who this confession from, he will only know you are his friend"
                                                                  attributes:attributtesFirst];
    [self.firstInfo setTextAlignment:NSTextAlignmentCenter];
    
    NSMutableParagraphStyle *styleSecond  = [[NSMutableParagraphStyle alloc] init];
    styleSecond.minimumLineHeight = 32.f;
    styleSecond.maximumLineHeight = 32.f;
    NSDictionary *attributtesSecond = @{NSParagraphStyleAttributeName : styleSecond,};
    self.secondInfo.attributedText = [[NSAttributedString alloc] initWithString:@"Your friend will recieve each confession seperatly"
                                                                    attributes:attributtesSecond];
    [self.secondInfo setTextAlignment:NSTextAlignmentCenter];
    
    NSMutableParagraphStyle *styleThird  = [[NSMutableParagraphStyle alloc] init];
    styleThird.minimumLineHeight = 32.f;
    styleThird.maximumLineHeight = 32.f;
    NSDictionary *attributtesThird = @{NSParagraphStyleAttributeName : styleThird,};
    self.thirdInfo.attributedText = [[NSAttributedString alloc] initWithString:@"If your friend does not have the app, it will be send by email with no relation to you"
                                                                     attributes:attributtesThird];
    [self.thirdInfo setTextAlignment:NSTextAlignmentCenter];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)screenTapped:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
