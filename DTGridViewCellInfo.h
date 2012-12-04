//
//  DTGridViewCellInfo.h
//  IGTiledView
//
//  Created by Ishaan Gulrajani on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTGridViewCellInfoProtocol.h"

@interface DTGridViewCellInfo : NSObject <DTGridViewCellInfoProtocol> {
	NSInteger xPosition, yPosition;
	CGRect frame;
	CGFloat x, y, width, height;
}
@property (nonatomic, assign) CGFloat x, y, width, height;
@end
