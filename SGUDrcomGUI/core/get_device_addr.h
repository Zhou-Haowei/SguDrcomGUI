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


#ifndef GET_DEVICE_ADDR_H_
#define GET_DEVICE_ADDR_H_

#include <stdint.h>
#include <vector>
#include <string.h>
using namespace std;

vector<uint8_t> get_mac_address(string device);

string get_ip_address(string device);

#endif
