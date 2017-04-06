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

#ifndef SOCKET_DEALER_H_
#define SOCKET_DEALER_H_

#include "def.h"
// #include <sys/socket.h>
// #include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <sys/select.h>
using namespace std;

const size_t RECV_BUFF_LEN = 2048;

class socket_dealer
{
public:
	socket_dealer(string gateway_ip, uint16_t gateway_port, string local_ip);
	bool send_udp_pkt(vector<uint8_t> &udp_data_set, vector<uint8_t> &recv, string &error);
	int wait_for_socket(int timeout_milisec = SOCKET_TIMEOUT_MILISEC);

	virtual ~socket_dealer();

private:
	int client_fd;
	struct sockaddr_in gateway;
	
};

#endif
