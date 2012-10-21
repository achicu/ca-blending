//
//  LayerSource.h
//  CABlending
//
//  Created by Chiculita Alexandru on 10/21/12.
//  Copyright (c) 2012 Chiculita Alexandru. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "CustomView.h"

@interface LayerSource : NSObject <NSOutlineViewDataSource>

@property (assign) IBOutlet CustomView *baseView;

@end
