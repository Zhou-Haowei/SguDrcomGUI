/**
 * Reconstructed:
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
 *
 *
 * Copyright (C) 2015 Shindo
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#import "AppDelegate.h"
#import "STPrivilegedTask.h"
#import "NSObject+extend.h"
#import "core/log.h"

#import <exception>
#import <iostream>
#import <fstream>
#import <sstream>

std::ofstream log_stream;
ONLINE_STATE DRCOM_STATE = OFFLINE;

MainDealer *dealer = nil;
NSThread *udpKeepAlive = nil;
NSThread *eapKeepAlive = nil;


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.window setDelegate:self];
    [self.btnConnect setBezelStyle:NSRoundedBezelStyle];
    [self.window setDefaultButtonCell:[self.btnConnect cell]];
    
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [self.window setTitle:[NSString stringWithFormat:@"SGUDrcomGUI For OSX, v%@", version]];
    SYS_LOG_INFO("SGUDrcomGUI For OSX, v" << [version UTF8String] << std::endl);
    
    connectMode = ConnectionModeStudentDistrict;
    
    statusIcon = [[NSStatusBar systemStatusBar]statusItemWithLength:NSVariableStatusItemLength];
    [statusIcon setImage:[NSImage imageNamed:@"offline"]];
    [statusIcon setHighlightMode:YES];
    statusIcon.target = self;
    
    
    // load nics
    SYS_LOG_INFO("First attempt to load NIC list...");
    bridge = [[PcapBridge alloc] init];
    NSArray *list = [bridge getNICList];
    NSAlert *alert = [NSAlert alertWithMessageText:@"使用须知！" defaultButton:@"好" alternateButton:nil otherButton:nil informativeTextWithFormat:@"受到系统和拨号协议限制，请阅读使用须知.md后，并在终端中执行相应命令后再运行SGUDrcomGUI"];
    [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
    if ([list count] == 0)
    {
        // hide window
        [self.window orderOut:self];
        if ([bridge lastError] != nil)
            SYS_LOG_DBG("lastError = " << [[bridge lastError] UTF8String]);
        
        SYS_LOG_INFO("Try to `chmod 666 /dev/bpf*`...");
        // try to grant access to /dev/bpf*
        NSArray *args = [NSArray arrayWithObjects:@"-c", @"chmod 666 /dev/bpf*", nil];
        STPrivilegedTask *task = [[STPrivilegedTask alloc] initWithLaunchPath:@"/bin/sh" arguments:args];
        // NSLog(@"%@", [task description]);
        
        int result = [task launch];
        if (result != noErr) // error occured
        {
            SYS_LOG_ERR("Failed to init, quit." << std::endl);
            [self.window makeKeyAndOrderFront:self];
            [NSApp activateIgnoringOtherApps:YES];
            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
            NSAlert *alert = [NSAlert alertWithMessageText:@"获取网卡信息失败！" defaultButton:@"好" alternateButton:nil otherButton:nil informativeTextWithFormat:@"请在终端中执行如下命令后再运行SGUDrcomGUI：\n\tsudo chmod 666 /dev/bpf*\n\n错误信息：\n%@", [error localizedFailureReason] ?: [error localizedDescription]];
            [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertFetchNICListFailed:returnCode:contextInfo:) contextInfo:nil];
            return;
        }
        
        // just wait for chmod
        [task waitUntilExit];
        SYS_LOG_INFO("Second attempt to load NIC list...");
        list = [bridge getNICList];
        if ([list count] == 0) // still failed
        {
            if ([bridge lastError] != nil)
                SYS_LOG_DBG("lastError = " << [[bridge lastError] UTF8String]);
            SYS_LOG_ERR("Failed to init, quit." << std::endl);
            [self.window makeKeyAndOrderFront:self];
            [NSApp activateIgnoringOtherApps:YES];
            NSAlert *alert = [NSAlert alertWithMessageText:@"获取网卡信息失败！" defaultButton:@"好" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", bridge.lastError ?: @"请在终端中执行如下命令后再运行SGUDrcomGUI：\n\tsudo chmod 666 /dev/bpf*"];
            [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertFetchNICListFailed:returnCode:contextInfo:) contextInfo:nil];
            return;
        }
    }
    
    [self.window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    [self.nicList addItemsWithTitles: list];
    
    // load settings
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    connectMode = ConnectionModeStudentDistrict;
    storedNIC = [userDefaults objectForKey:@"stuDist.storedNIC"];
    storedUserName = [userDefaults objectForKey:@"stuDist.storedUserName"];
    storedPassWord = [userDefaults objectForKey:@"stuDist.storedPassWord"];
    if (storedNIC != nil)
    {
        if ([self.nicList itemWithTitle:storedNIC] != nil)
            [self.nicList selectItemWithTitle:storedNIC];
    }
    if (storedUserName != nil) [self.userName setStringValue:storedUserName];
    if (storedPassWord != nil) [self.passWord setStringValue:storedPassWord];
    
    SYS_LOG_INFO("SGUDrcomGUI is ready." << std::endl);
}

- (void) alertFetchNICListFailed:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [[NSApplication sharedApplication] terminate:self];
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender
{
    if (connectJob)
    {
        NSAlert *alert = [NSAlert alertWithMessageText:@"确定要退出吗？" defaultButton:@"否" alternateButton:@"是" otherButton:nil informativeTextWithFormat:@"一旦退出SGUDrcomGUI，您将会在稍后失去网络连接。"];
        [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertQuitApplication: returnCode:contextInfo:) contextInfo:nil];
        return NSTerminateLater;
    }
    else
    {
        SYS_LOG_INFO("SGUDrcomGUI quit." << std::endl);
        
        return NSTerminateNow;
    }
}

- (void) alertQuitApplication:(NSAlert*)alert returnCode:(NSInteger)returnCode contextInfo:(void*)contextInfo
{
    if (returnCode != NSAlertDefaultReturn)
        [[NSApplication sharedApplication] replyToApplicationShouldTerminate:YES];
    else
        [[NSApplication sharedApplication] replyToApplicationShouldTerminate:NO];
}

- (BOOL) windowShouldClose:(id)sender
{
    [[NSRunningApplication currentApplication] hide];
    return NO;
}

- (IBAction) connectClicked:(id)sender
{
    NSString *btnValue = [self.btnConnect title];
    if ([btnValue isEqualToString:@"连接"])
    {
        storedNIC = [[self.nicList selectedItem] title];
        storedUserName = [self.userName stringValue];
        storedPassWord = [self.passWord stringValue];
      
        if (storedUserName.length == 0 || storedPassWord.length == 0)
        {
            NSAlert *alert = [NSAlert alertWithMessageText:@"错误" defaultButton:@"好" alternateButton:nil otherButton:nil informativeTextWithFormat:@"账户或密码不能为空！"];
            [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            return;
        }
        
        SYS_LOG_INFO("Prepare to authenticate..." << std::endl);
        
        // save settings
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        [userDefaults setObject:[[self.nicList selectedItem] title] forKey:@"stuDist.storedNIC"];
        [userDefaults setObject:[self.userName stringValue] forKey:@"stuDist.storedUserName"];
        [userDefaults setObject:[self.passWord stringValue] forKey:@"stuDist.storedPassWord"];
        
        SYS_LOG_DBG("UserName = " << [storedUserName UTF8String] << ", PassWord = " << [storedPassWord UTF8String] << std::endl);
        
        // get ip & mac
        SYS_LOG_INFO("Attempt to fetch IP & MAC...");
        storedIP = [bridge getIPAddressWithNICName:storedNIC];
        storedMAC = [bridge getMACAddressWithNICName:storedNIC];
        if (storedIP == nil || storedMAC == nil)
        {
            if ([bridge lastError] != nil)
            {
                SYS_LOG_ERR("lastError = " << [[bridge lastError] UTF8String] << std::endl);
            }
            
            NSAlert *alert = [NSAlert alertWithMessageText:@"获取网卡信息失败！" defaultButton:@"好" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", [bridge lastError] ?: @"Unknown error occured."];
            [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            return;
        }
        
        [self.lblIPAddr setStringValue:storedIP];
        [self.lblMacAddr setStringValue:storedMAC];
        SYS_LOG_DBG("IP = " << [storedIP UTF8String] << ", MAC = " << [storedMAC UTF8String] << std::endl);
        SYS_LOG_INFO("Preparation done." << std::endl);
        connectJob = [[NSThread alloc] initWithTarget:self selector:@selector(connectionJobForStudentDistrict) object:nil];

        [self.lblStatus setStringValue: @"准备连接中……"];
        [self.lblOnlineTime setStringValue: @"00:00:00"];
        
        [self.nicList setEnabled:NO];
        [self.userName setEnabled:NO];
        [self.passWord setEnabled:NO];
        [self.btnConnect setEnabled:NO];
        
        [connectJob start];
    }
    else if ([btnValue isEqualToString:@"断开"])
    {
        [self.btnConnect setEnabled:NO];
        if (udpKeepAlive != nil && [udpKeepAlive isExecuting])
            [udpKeepAlive cancel];
        if (eapKeepAlive != nil && [eapKeepAlive isExecuting])
            [eapKeepAlive cancel];
        [connectJob cancel];
    }
}

- (void) resetOnlineTime
{
    if (connectTimer != nil)
    {
        [connectTimer cancel];
        connectTimer = nil;
    }
        
    connectTime = 0;
    [self.lblOnlineTime setStringValue:@"00:00:00"];
}


- (void) updateOnlineTime
{
    while ([[NSThread currentThread] isCancelled] == NO)
    {
        ++connectTime;
        
        NSInteger seconds = connectTime % 60;
        NSInteger minutes = (connectTime / 60) % 60;
        NSInteger hours = connectTime / 3600;
        
        [self.lblOnlineTime setStringValue: [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, (long)seconds]];
        
        [NSThread sleepForTimeInterval:1.0f];
    }
}

- (void) notificateWithString:(NSString *)string notificateType:(NSString *)type
{
    SYS_LOG_INFO("Gateway notificate - " << [type UTF8String] << ": " << [string UTF8String] << std::endl);
    NSString *title = [NSString stringWithFormat:@"网关通知 - %@", type];
    NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:@"好" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", string];
    [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

-(bool) loginProcess{
    [dealer logOff];
    [dealer logOff];
    sleep(2);
    
    [self.lblStatus setStringValue:@"802.1X认证中……"];
    if (![dealer start] ||
        ![dealer responseIdentity] ||
        ![dealer responseMD5Challenge])
    {
        DRCOM_STATE = OFFLINE;
        return false;
    }
    DRCOM_STATE = ONLINE;
    try{
        udpKeepAlive = [[NSThread alloc] initWithTarget:self selector:@selector(udpAliveWithDealer:) object:dealer];
        [udpKeepAlive start];
    }
    catch(std::exception &e){
        return false;
    }
    return true;
}

- (void) eapAliveWithDealer: (MainDealer*) dealer
{
    [NSThread sleepForTimeInterval:3.0f];
    while (![[NSThread currentThread] isCancelled])
    {
        if (DRCOM_STATE == OFFLINE) break;
        int ret = [dealer recvGatewayReturn];
        if (ret == 1) // receive failure packet
        {
            EAP_LOG_INFO("Gateway Returns: Failure.");
            DRCOM_STATE = OFFLINE; // receive the failure packet, try to reconnect
        }
        else if (ret == 0) // request identity and send alive
        {
            [dealer eapAliveIdentity];
        }
    }
    [NSThread exit];
}


- (void) udpAliveWithDealer: (MainDealer*) dealer
{
    [dealer clearAllParams];
    [dealer sendU8Packet];
    [dealer sendU244Packet];
    while (![[NSThread currentThread] isCancelled])
    {
        int counter = 1;
        if ([[NSThread currentThread] isCancelled]) break;
        if (DRCOM_STATE == OFFLINE) break;
        [dealer sendU40AlivePacket1];
        [NSThread sleepForTimeInterval:0.3f];
        [dealer sendU40AlivePacket2];
        [NSThread sleepForTimeInterval:6.0f];
        [dealer sendU38Packet];
        [NSThread sleepForTimeInterval:3.0f];
        if (counter >= 10)
        {
            [dealer sendU40AlivePacket3];
            counter = 1;
            sleep(1);
        }
        else
            counter++;
    }
    return;
}

- (void) connectionJobForStudentDistrict
{
    try {
        dealer = [[MainDealer alloc] initWithNICName:storedNIC userName:storedUserName passWord:storedPassWord IPAddress:storedIP MacAddress:storedMAC];
    }
    catch (std::exception&) {
        DRCOM_STATE = OFFLINE;
        [self.lblStatus setStringValue:@"802.1X认证失败！"];
        goto firstFail;
    }
    
    [self.lblStatus setStringValue:@"802.1X清理中……"];
    sleep(2);
    [self.lblStatus setStringValue:@"802.1X认证中……"];
    if(![self loginProcess]) {
        DRCOM_STATE = OFFLINE;
        [self.lblStatus setStringValue:@"802.1X认证失败！"];
        goto firstFail;
    }
    
    try {
        eapKeepAlive = [[NSThread alloc] initWithTarget:self selector:@selector(eapAliveWithDealer:) object:dealer];
        [eapKeepAlive start];
        [self.lblStatus setStringValue:@"已连接上"];
        [self.btnConnect setEnabled:YES];
        [self.btnConnect setTitle:@"断开"];
        connectTimer = [[NSThread alloc] initWithTarget:self selector:@selector(updateOnlineTime) object:dealer];
        [connectTimer start];
        [statusIcon setImage:[NSImage imageNamed:@"online"]];
    }
    catch (std::exception&) {
        DRCOM_STATE = OFFLINE;
        [self.lblStatus setStringValue:@"802.1X认证失败！"];
        goto firstFail;
    }
    // prevent app nap
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(beginActivityWithOptions:reason:)])
        self.activity = [[NSProcessInfo processInfo] beginActivityWithOptions:0x00FFFFFF reason:@"receiving gateway keep-alive packets"];

    while (![connectJob isCancelled])
    {
        if([connectJob isCancelled]) break;
        if(DRCOM_STATE == OFFLINE) break;
        continue;
    }
    
    // canceled
    if (udpKeepAlive != nil && [udpKeepAlive isExecuting])
        [udpKeepAlive cancel];
    if (eapKeepAlive != nil && [eapKeepAlive isExecuting])
        [eapKeepAlive cancel];
    [self.lblStatus setStringValue:@"802.1X注销中……"];
    [dealer logOff];
    
    if (self.activity)
        [[NSProcessInfo processInfo] endActivity:self.activity];
    self.activity = nil;
    [self.lblStatus setStringValue:@"已断开"];
    
    
firstFail:
    if (udpKeepAlive != nil && [udpKeepAlive isExecuting])
        [udpKeepAlive cancel];
    if (eapKeepAlive != nil && [eapKeepAlive isExecuting])
        [eapKeepAlive cancel];
    [self resetOnlineTime];
    [self.nicList setEnabled:YES];
    [self.userName setEnabled:YES];
    [self.passWord setEnabled:YES];
    [self.btnConnect setEnabled:YES];
    
    [self.lblIPAddr setStringValue:@"-"];
    [self.lblMacAddr setStringValue:@"-"];
    [self.btnConnect setTitle:@"连接"];
    //[self.connectIndicator setHidden:YES];
    [statusIcon setImage:[NSImage imageNamed:@"offline"]];
    connectJob = nil;
}



@end
