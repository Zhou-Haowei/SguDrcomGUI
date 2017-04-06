/**
 * Copyright (C) 2017 Edward & Steven
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


#include "def.h"
#include "get_device_addr.h"
#include "sgudrcom_exception.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <net/ethernet.h>
#include <netinet/in.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/sysctl.h>

vector<uint8_t> get_mac_address(string device)
{
    int                     mib[6] = { CTL_NET, AF_ROUTE, 0, AF_LINK, NET_RT_IFLIST, 0 };
    size_t                  len;
    char*                   buf;
    uint8_t                 *ptr;
    struct if_msghdr        *ifm;
    struct sockaddr_dl      *sdl;
    std::vector<uint8_t>    ret(6, 0);
    
    if ((mib[5] = if_nametoindex(device.c_str())) == 0)
        throw sgudrcom_exception("get_mac_address: if_nametoindex failed", errno);
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
        throw sgudrcom_exception("get_mac_address: sysctl failed", errno);
    
    buf = new char[len];
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
        throw sgudrcom_exception("get_mac_address: sysctl failed", errno);
    
    ifm = (struct if_msghdr *) buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (uint8_t *) LLADDR(sdl);
    
    memcpy(&ret[0], ptr, 6);
    delete[] buf;
    return ret;

}

string get_ip_address(string device)
{
    struct ifaddrs *ifaddr = NULL;
    std::string ip;
    
    if (getifaddrs(&ifaddr) < 0) {
        throw sgudrcom_exception("get_ip_address: getifaddrs failed", errno);
    }
    bool found = false;
    struct ifaddrs * ifa;
    for( ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next)
    {
        if (!strcmp(ifa->ifa_name, device.c_str()))
            if (ifa->ifa_addr->sa_family == AF_INET) // only deal with IPv4
            {
                ip = inet_ntoa(((struct sockaddr_in*)ifa->ifa_addr)->sin_addr);
                found = true; break;
            }
    }
    
    if (!found) {
        throw sgudrcom_exception("get_ip_address: NIC '" + device + "' not found.", errno);
    }
    return ip;
}
