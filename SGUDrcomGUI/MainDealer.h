/**
 * Copyright (C) 2017 Steven
 *
 * Licensed under the GPL, Version 3.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
 *​             
 *               <http://fsf.org/>
 *
 * Everyone is permitted to copy and distribute verbatim copies of this license document.
 * Changing it is not allowed.
 *
 */

#import "DrcomDealer.h"
#include "core/eap_dealer.h"
#include "core/udp_dealer.h"

#import <memory>
class eap_dealer;
class udp_dealer;

@interface MainDealer : DrcomDealer
{
    std::shared_ptr<eap_dealer> eap;
    std::shared_ptr<udp_dealer> udp;
}
- (id) initWithNICName: (NSString*)_device userName:(NSString *)_userName passWord:(NSString *)_passWord IPAddress:(NSString*)_ip MacAddress:(NSString*)_mac;

- (BOOL) isEAPObjectInit;
- (BOOL) isUDPObjectInit;

// EAP
- (void) logOff;
- (BOOL) start;
- (BOOL) responseIdentity;
- (BOOL) responseMD5Challenge;
- (int) recvGatewayReturn;
- (BOOL) eapAliveIdentity;

// UDP
- (void) sendU8Packet;
- (void) sendU244Packet;
- (void) sendU38Packet;
- (void) sendU40AlivePacket1;
- (void) sendU40AlivePacket2;
- (void) sendU40AlivePacket3;
- (void) clearAllParams;

@end
