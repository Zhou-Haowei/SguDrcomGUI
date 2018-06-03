/**
 *
 * Copyright (C) 2017 Steven
 *
 * Licensed under the GPL, Version 3.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
 *
 *               <http://fsf.org/>
 *
 * Everyone is permitted to copy and distribute verbatim copies of this license document.
 * Changing it is not allowed.
 *
 */
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "PcapBridge.h"
#import "MainDealer.h"

typedef NSInteger ConnectionMode;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
{
    NSString *logPath;
    
    NSThread* connectTimer;
    NSInteger connectTime;
    PcapBridge* bridge;

    NSString *storedNIC, *storedUserName, *storedPassWord, *storedIP, *storedMAC;
    NSThread *connectJob;
    
    NSStatusItem *statusIcon;
}

@property (strong) id activity;

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, retain) IBOutlet NSButton *reconnectMode;
@property (nonatomic, retain) IBOutlet NSPopUpButton *nicList;
@property (nonatomic, retain) IBOutlet NSTextField *userName;
@property (nonatomic, retain) IBOutlet NSTextField *passWord;
@property (nonatomic, retain) IBOutlet NSButton *btnConnect;


@property (nonatomic, retain) IBOutlet NSTextField *lblStatus;
@property (nonatomic, retain) IBOutlet NSTextField *lblOnlineTime;
@property (nonatomic, retain) IBOutlet NSTextField *lblIPAddr;
@property (nonatomic, retain) IBOutlet NSTextField *lblMacAddr;
@property (nonatomic, retain) IBOutlet NSTextField *lblBuild;

- (IBAction) connectClicked:(id)sender;

- (void) alertFetchNICListFailed:(NSAlert*)alert returnCode:(NSInteger)returnCode contextInfo:(void*)contextInfo;
- (void) alertQuitApplication:(NSAlert*)alert returnCode:(NSInteger)returnCode contextInfo:(void*)contextInfo;
- (void) openWindow:(id)sender;

- (void) updateOnlineTime;

- (bool) loginProcess;

- (void) connectionJobForStudentDistrict;

- (void) eapAliveWithDealer: (MainDealer*)dealer;
- (void) udpAliveWithDealer: (MainDealer*)dealer;

- (void) resetOnlineTime;
//- (void) notificateWithString:(NSString*) string notificateType:(NSString*) type;

@end
