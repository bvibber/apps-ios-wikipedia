//
//  DataMigrationProgress.m
//  Wikipedia
//
//  Created by Brion on 1/13/15.
//  Copyright (c) 2015 Wikimedia Foundation. All rights reserved.
//

#import "DataMigrationProgress.h"

#import "SessionSingleton.h"

#import "OldDataSchema.h"
#import "SchemaConverter.h"

#import "DataMigrator.h"
#import "ArticleImporter.h"


@interface DataMigrationProgress ()

@property (readonly) OldDataSchema *oldDataSchema;
@property (readonly) DataMigrator *dataMigrator;

@end

@implementation DataMigrationProgress {
    OldDataSchema *_oldDataSchema;
    DataMigrator *_dataMigrator;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self asyncMigration];
}

-(OldDataSchema *)oldDataSchema
{
    if (_oldDataSchema == nil) {
        _oldDataSchema = [[OldDataSchema alloc] init];
    }
    return _oldDataSchema;
}

-(DataMigrator *)dataMigrator
{
    if (_dataMigrator == nil) {
        _dataMigrator = [[DataMigrator alloc] init];
    }
    return _dataMigrator;
}

-(BOOL)needsMigration
{
    return [self.oldDataSchema exists] || [self.dataMigrator hasData];
}

-(void)syncMigration
{
    // Middle-Ages Converter
    // From the native app's initial CoreData-based implementation,
    // which now lives in OldDataSchema subproject.
    if ([self.oldDataSchema exists]) {
        SchemaConverter *schemaConverter = [[SchemaConverter alloc] initWithDataStore:[SessionSingleton sharedInstance].dataStore];
        self.oldDataSchema.delegate = schemaConverter;
        NSLog(@"begin migration");
        [self.oldDataSchema migrateData];
        NSLog(@"end migration");
        
        [self.oldDataSchema removeOldData];
        
        // hack for history fix
        [[SessionSingleton sharedInstance].userDataStore reset];
        
        return;
    }
    
    // Ye Ancient Converter
    // From the old PhoneGap app
    // @fixme: fix this to work again
    if ([self.dataMigrator hasData]) {
        NSLog(@"Old data to migrate found!");
        NSArray *titles = [self.dataMigrator extractSavedPages];
        ArticleImporter *importer = [[ArticleImporter alloc] init];
        
        for (NSDictionary *item in titles) {
            NSLog(@"Will import saved page: %@ %@", item[@"lang"], item[@"title"]);
        }
        
        [importer importArticles:titles];
        
        [self.dataMigrator removeOldData];
        
        return;
    }
    
    NSLog(@"No old data to migrate.");
}

-(void)asyncMigration
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        [self syncMigration];
        dispatch_async(dispatch_get_main_queue(), ^() {
            [self.delegate dataMigrationProgressComplete:self];
        });
    });
}
@end
