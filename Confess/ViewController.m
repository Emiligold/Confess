//
//  ViewController.m
//  Confess
//
//  Created by Noga badhav on 30/09/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "ViewController.h"
#import "FriendsTab.h"

@interface ViewController ()

-(void)toggleHiddenState:(BOOL)shouldHide;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self toggleHiddenState:YES];
    self.content.lineBreakMode = NSLineBreakByWordWrapping;
    self.content.numberOfLines = 2;
    self.content.textColor = [UIColor blackColor];
    self.content.textColor = [UIColor colorWithRed:(125/255.0) green:(128/255.0) blue:(130/255.0) alpha:1];
    self.content.layer.shadowColor = [self.content.textColor CGColor];
    self.content.layer.shadowOffset = CGSizeMake(2.5, 2.5);
    self.content.layer.shadowRadius = 3.5;
    self.content.layer.shadowOpacity = 0.0;
    self.content.layer.masksToBounds = NO;
    self.content.font = [UIFont systemFontOfSize:14];
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 30.f;
    style.maximumLineHeight = 30.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    self.content.attributedText = [[NSAttributedString alloc] initWithString:@"Text your friend anonymously what you didn't have the courage to tell"
                                                                  attributes:attributtes];
    [self.content sizeToFit];
    [self.content setTextAlignment:NSTextAlignmentCenter];
    self.continueNoFacebook.hidden = true;
    self.loginView = [[FBLoginView alloc] init];
    self.loginView.delegate = self;
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginView.center = CGPointMake(160, 220);
    [self.view addSubview:self.loginView];
    self.loginView.hidden = true;
    //self.view.backgroundColor = [UIColor colorWithRed:(214/255.0) green:(195/255.0) blue:(163/255.0) alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    self.startButton.alpha = 0.0;
    [self.view addSubview:self.startButton];
    [UIView animateWithDuration:5.0
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{self.startButton.alpha = 1.0;}
                     completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startClicked:(id)sender {
    self.startButton.hidden = YES;
    self.content.hidden = YES;
    self.loginView.hidden = NO;
    self.continueNoFacebook.hidden = NO;
}

-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations:@"Fade In" context:nil];
    [UIView setAnimationDelay:wait];
    [UIView setAnimationDuration:duration];
    self.startButton.alpha = 1;
    [UIView commitAnimations];
}

-(void)toggleHiddenState:(BOOL)shouldHide{
    //self.content.hidden = shouldHide;
    //self.lblEmail.hidden = shouldHide;
    //self.profilePicture.hidden = shouldHide;
    //self.content.hidden = YES;
    self.continueNoFacebook.hidden = YES;
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    //self.lblLoginStatus.text = @"You are logged in.";
    
    [self toggleHiddenState:NO];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    //self.profilePicture.profileID = user.id;
    //self.lblUsername.text = user.name;
    //self.lblEmail.text = [user objectForKey:@"email"];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    //self.content.text = @"You are logged out";
    
    [self toggleHiddenState:YES];
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

- (IBAction)continueWithoutFacebookClicked:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Continue without Facebook?" message:@"Confess contacts only" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabController"];
        tbc.selectedIndex=1;
        [self presentViewController:tbc animated:YES completion:nil];
    }
}

@end
