//
//  IGTiledViewAppDelegate.m
//  IGTiledView
//
//  Created by Ishaan Gulrajani on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "IGTiledViewAppDelegate.h"
#import "IGTiledViewController.h"

@implementation IGTiledViewAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	tiledViewController = [[IGTiledViewController alloc] init];
	[window addSubview:tiledViewController.view];    
	
	[window makeKeyAndVisible];

    return YES;
}


- (void)dealloc {
    [window release];
    [tiledViewController release];
	[super dealloc];
}


@end
