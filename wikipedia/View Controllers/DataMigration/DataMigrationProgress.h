//
//  DataMigrationProgress.h
//  Wikipedia
//
//  Created by Brion on 1/13/15.
//  Copyright (c) 2015 Wikimedia Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataMigrationProgress;

@protocol DataMigrationProgressDelegete
-(void)dataMigrationProgressComplete:(DataMigrationProgress *)viewController;
@end


@interface DataMigrationProgress : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) id<DataMigrationProgressDelegete> delegate;

-(BOOL)needsMigration;

@end
