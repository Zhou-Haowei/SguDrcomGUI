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

#ifndef SGUDRCOM_EXCEPTION_H_
#define SGUDRCOM_EXCEPTION_H_

#include <iostream>
#include <sstream>
#include <string.h>
#include <exception>
using namespace std;

class sgudrcom_exception : public exception
{
public:
	sgudrcom_exception(const string& message) : message(message) { }
	sgudrcom_exception(const string& message, int err) { // system error
        stringstream stream;
        stream << message << ", errno = " << err << ", desc: " << strerror(err);
        this->message = stream.str();
    }
	const char * what() const throw() { return message.c_str(); }
    virtual ~sgudrcom_exception() throw() { }

private:
	string message;
};

#endif
