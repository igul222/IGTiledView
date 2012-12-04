//
//  IGTile.m
//  IGTiledView
//
//  Created by Ishaan Gulrajani on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IGTile.h"
#import "IGTiledView.h"

@implementation IGTile
@synthesize tiledView;

#pragma mark -
#pragma mark Dealloc

-(void)dealloc {	
	[overlay release];
	[super dealloc];
}

#pragma mark -
#pragma mark Interaction

// in touchesMoved:, we call touchesCancelled: manually. the issue with this
// is that touchesEnded: is still called later. we work around this with a 
// boolean "touchesCancelled".

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	touchCanceled = NO;
	[self showOverlay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self hideOverlay];
	
	if(!touchCanceled) {
		// if tiledView is nil, this will, of course, do nothing.
		[tiledView tileTouched:self];
	}
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	touchCanceled = YES;
	[self hideOverlay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	// if the touch is dragged too far off, cancel it.
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	
	if(
	   (location.x < -50.0f) ||
	   (location.x > self.frame.size.width+50.0f) ||
	   (location.y < -50.0f) ||
	   (location.y > self.frame.size.height+50.0f)
	) {
		[self touchesCancelled:touches withEvent:event];
	}
	
}

-(void)showOverlay {
	if(overlay)
		return;
	
	overlay = [[CALayer alloc] init];
	overlay.frame = self.bounds;
	overlay.backgroundColor = [[UIColor blackColor] CGColor];
	overlay.opacity = 0.5f;
	[self.layer addSublayer:overlay];
	[self setNeedsDisplay];
	
}

-(void)hideOverlay {
	if(!overlay)
		return;
		
	[overlay removeFromSuperlayer];
	[overlay release];
	overlay = nil;
}

#pragma mark -
#pragma mark Resetting

-(void)reset {
	self.transform = CGAffineTransformIdentity;
}

@end
