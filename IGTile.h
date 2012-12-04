//
//  IGTile.h
//  IGTiledView
//
//  Created by Ishaan Gulrajani on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class IGTiledView;
@interface IGTile : UIView {
	CALayer *overlay;
	BOOL touchCanceled;
	
	IGTiledView *tiledView;
}
@property(nonatomic,assign) IGTiledView *tiledView;

// IGTile subclasses can override this to toggle their "selected" state on/off
-(void)showOverlay;
-(void)hideOverlay;

// this is called by IGTiledView to prepare the tile for reuse. don't call it directly.
-(void)reset;

@end
