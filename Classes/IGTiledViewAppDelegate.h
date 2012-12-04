//
//  IGTiledViewAppDelegate.h
//  IGTiledView
//
//  Created by Ishaan Gulrajani on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IGTiledViewController;

@interface IGTiledViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IGTiledViewController *tiledViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

