//
//  LogInContainer.m
//  Confess
//
//  Created by Noga badhav on 26/09/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "LogInContainer.h"
#import "AppDelegate.h"

@interface LogInContainer ()

@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
- (IBAction)skipClicked:(id)sender;
- (IBAction)logInClicked:(id)sender;

@end

@implementation LogInContainer

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

    self.logInButton.layer.cornerRadius = 23;
    self.logInButton.clipsToBounds = YES;
    self.skipButton.layer.cornerRadius = 23;
    self.skipButton.clipsToBounds = YES;
    //self.skipButton.backgroundColor = [UIColor clearColor];
    //[[self.skipButton layer] setBorderWidth:2.0f];
    //[[self.skipButton layer] setBorderColor:[UIColor whiteColor].CGColor];
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

- (IBAction)skipClicked:(id)sender
{
    [self.logInViewController.modalView addSubview:self.logInViewController.skipContainer];
    [self.logInViewController.view addSubview:self.logInViewController.modalView];
    self.logInViewController.skipContainer.hidden = NO;
}

- (IBAction)logInClicked:(id)sender
{
    //dispatch_queue_t downloadQuqeue = dispatch_queue_create("download", NULL);
    //dispatch_async(downloadQuqeue, ^{

    //TODO: Decide if need email
    FBSession *fbSession = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:
                                                                   @"public_profile", /*@"email",*/ @"user_friends", nil]];
    [fbSession openWithBehavior:FBSessionLoginBehaviorForcingSafari completionHandler:^(FBSession *session,FBSessionState state, NSError *error)
     {


         
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [spinner stopAnimating];
    //    });
    //});
         
         [FBSession setActiveSession:fbSession]; // Retain the Active Session.
         // Retrieve the app delegate
         AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
         
     }];
}

-(void)initProperties:(ViewController*)viewController
{
    self.logInViewController = viewController;
}

- (IBAction)exitClicked:(id)sender
{
    self.logInViewController.logInContainer.hidden = YES;
    [self.logInViewController.modalView removeFromSuperview];
    self.logInViewController.startButton.hidden = NO;
}

@end
