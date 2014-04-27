//
//  AppDelegate.h
//  Bookio
//
//  Created by Devashi Tandon on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

// Reference : http://www.codigator.com/tutorials/ios-core-data-tutorial-with-example/
// the 3 variable declared below are declared to be used by core data

// This model gives the models for all entities in the database
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;

// This acts as a temporary space in which the data can be altered before actaully updating the modification in the persistent store
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

// This property co-ordinates between the context and the underlying sqlite database(persitent storage)
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

@property (nonatomic,strong) UIWindow *window;
@property (nonatomic,retain) NSMutableDictionary *userData;

@property (strong, nonatomic) LoginViewController *loginViewController;



- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;

@end
