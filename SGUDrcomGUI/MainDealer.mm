/**
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

#import "MainDealer.h"

#include <iostream>
#include <sstream>
#include <vector>
#include <stdexcept>
#include <functional>
#include <ctime>
#include <fstream>
#include <cctype>

#include <thread>

#if defined(__APPLE__) || defined(LINUX) || defined(linux)
#include <sys/types.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <net/ethernet.h>
#endif

#define EASYDRCOM_DEBUG

#include "core/sgudrcom_exception.h"
#include "core/log.h"
#include "core/utils.h"
#include "core/pcap_dealer.h"


@implementation MainDealer
std::vector<uint8_t> broadcast_mac = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
std::vector<uint8_t> nearest_mac = { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x03 };
std::vector<uint8_t> gateway_eap_mac = { 0x58, 0x6a, 0xb1, 0x56, 0x78, 0x00 };
std::vector<uint8_t> gateway_udp_mac = { 0x58, 0x6a, 0xb1, 0x56, 0x79, 0x00 };


- (id) initWithNICName: (NSString*) _device userName:(NSString *)_userName passWord:(NSString *)_passWord IPAddress:(NSString *)_ip MacAddress:(NSString *)_mac
{
    if (self = [super initWithNICName:_device userName:_userName passWord:_passWord IPAddress:_ip MacAddress:_mac])
    {
        try {
            eap = std::shared_ptr<eap_dealer>(new eap_dealer([device UTF8String], gateway_eap_mac,str_mac_to_vec([mac UTF8String]), [ip UTF8String], [userName UTF8String], [passWord UTF8String]));
        } catch (std::exception& ex) {
            EAP_LOG_ERR(ex.what() << std::endl);
            throw sgudrcom_exception(ex.what()); // throw out to the loop
        }
        
        try {
            udp = std::shared_ptr<udp_dealer>(new udp_dealer(str_mac_to_vec([mac UTF8String]), [ip UTF8String],"192.168.127.129", 61440));
        } catch (std::exception& ex) {
            SYS_LOG_ERR(ex.what() << std::endl);
            throw sgudrcom_exception(ex.what()); // throw out to the loop
        }
    }
    return self;
}

- (void) dealloc
{
    eap.reset();
    udp.reset();
}

- (BOOL) isEAPObjectInit
{
    return eap != nullptr;
}

- (BOOL) isUDPObjectInit
{
    return udp != nullptr;
}

- (void) logOff
{
    eap->logoff();
}

-(BOOL) start
{
    return eap->start();
}

-(BOOL) responseIdentity
{
    return eap->response_identity();
}

-(BOOL) responseMD5Challenge
{
    return eap->response_md5_challenge();
}

- (int) recvGatewayReturn
{
    return eap->recv_gateway_returns();
}

- (BOOL) eapAliveIdentity
{
    return eap->alive_identity();
}

- (void) sendU8Packet
{
    udp->send_u8_pkt();
}
- (void) sendU244Packet
{
    udp->send_u244_pkt([userName UTF8String], "Macbook", "202.96.128.166", "210.38.192.33");
}

- (void) sendU38Packet
{
    udp->sendalive_u38_pkt(eap->md5_value);
}

-(void) sendU40AlivePacket1
{
    udp->sendalive_u40_1_pkt();
}

-(void) sendU40AlivePacket2
{
    udp->sendalive_u40_2_pkt();
}

-(void) sendU40AlivePacket3
{
    udp->sendalive_u40_3_pkt();
}

-(void) clearAllParams
{
    udp->clear_udp_param();
}

+ (BOOL) testNICAccessibility:(NSString *)deviceName{
    NSLog(@"%s","Don't have the access of this NIC");
    return pcap_dealer::testNICAccessibility([deviceName UTF8String]);
}

@end
