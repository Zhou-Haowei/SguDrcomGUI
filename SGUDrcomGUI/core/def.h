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

#ifndef HEADER_DEF_H_
#define HEADER_DEF_H_

#include <iostream>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <vector>
#include <string.h>

#define SGUDRCOM_DEBUG
const int SOCKET_TIMEOUT_MILISEC = 2000;
const int MAX_RETRY_TIME = 2;
const int RETRY_SLEEP_TIME = 2;

struct drcom_config
{
    std::string device;
    std::string username;
    std::string password;
    std::string authserver_ip;
    uint16_t udp_alive_port;
};

enum ONLINE_STATE
{
    OFFLINE_PROCESSING,
    OFFLINE,
    ONLINE_PROCESSING,
    ONLINE
};

#endif
