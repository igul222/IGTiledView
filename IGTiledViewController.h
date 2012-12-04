//
//  TiledExampleViewController.h
//  IGTiledView
//
//  Created by Ishaan Gulrajani on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGTiledView.h"
// IGTiledViewController should be imported from everywhere else, so we
// import this even through it's not needed here.
#import "IGTile.h"

@interface IGTiledViewController : UIViewController <IGTiledViewDataSource, IGTiledViewDelegate> {
	IGTiledView *tiledView;
	NSMutableArray *tiles;
}
@property(nonatomic,retain) IGTiledView *tiledView;

@end
