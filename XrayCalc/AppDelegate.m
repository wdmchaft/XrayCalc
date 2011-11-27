//
//  AppDelegate.m
//  XrayCalc
//
//  Created by Tim Robb on 20110915.
//  Copyright (c) 2011 InvaderTim. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Core.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (void)dealloc {
    [_window release];
    [_navigationController release];
    [super dealloc];
}

-(void)popViewStack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if([navigationController.viewControllers count] > 1) {
        UIButton *backButton = [[UIButton alloc] init];
        
        UIImage *backImage = [[UIImage imageNamed:@"NavigationBack.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:0];
        UIImage *backImagePressed = [[UIImage imageNamed:@"NavigationBackPressed.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:0];
        [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
        [backButton setBackgroundImage:backImagePressed forState:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(popViewStack:) forControlEvents:UIControlEventTouchUpInside];
        
        UIViewController *previousView = [navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-2];
        NSString *textText = previousView.title;
        if(textText == @"" || textText == nil)
            textText = @"Back";
        UIFont *font = [UIFont boldSystemFontOfSize:13.0f];
        CGSize textSize = [textText sizeWithFont:font];
        
        backButton.frame = CGRectMake(0, 0, (textSize.width*1.26)+10, 30);
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake((textSize.width*0.2)+5, 6, textSize.width+2, textSize.height)];
        text.font = font;
        text.textColor = [UIColor whiteColor];
        text.textAlignment = UITextAlignmentRight;
        text.backgroundColor = [UIColor clearColor];
        text.text = textText;
        
        [backButton addSubview:text];
        [text release];
        
        viewController.navigationItem.hidesBackButton = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        [backButton release];
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if([viewController respondsToSelector:@selector(hidesToolbar)]) {
        [navigationController setToolbarHidden:((BOOL)[viewController performSelector:@selector(hidesToolbar)]) animated:YES];
    } else {
        [navigationController setToolbarHidden:YES animated:YES];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [[Core getInstance] launchInitalization];
	[[CoreNetwork getInstance] init];
    
    self.navigationController = [[[NSBundle mainBundle] loadNibNamed:@"UINavigationBlueBar" owner:self options:nil] lastObject];
    self.navigationController.delegate = self; 
    [self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    
    UIImageView *launchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    //launchImage.frame = CGRectMake(0, 0, 320, 480);
    [self.navigationController.view addSubview:launchImage];
    [launchImage release];
    
    [UIView beginAnimations:@"InitialFadeIn" context:nil];
    [UIView setAnimationDelegate:launchImage];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView setAnimationDelay:0.0]; // stay on this long extra
    [UIView setAnimationDuration:1]; // transition speed
    [launchImage setAlpha:0.0];
    [UIView commitAnimations];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [[Core getInstance] saveContext];
}

@end
