/*
 *
 * Include file for tclspi package
 *
 * Copyright (C) 2013 by FlightAware, All Rights Reserved
 *
 * Freely redistributable under the Berkeley copyright, see license.terms
 * for details.
 */

#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <linux/spi/spidev.h>

extern int
tclspi_spiObjCmd(ClientData clientData, Tcl_Interp *interp, int objc, Tcl_Obj *CONST objvp[]);

typedef struct tclspi_clientData
{
    int fd;
    Tcl_Interp *interp;
    Tcl_Command cmdToken;
    struct spi_ioc_transfer transfer;
    uint8_t readBits;
    uint8_t writeBits;
    uint8_t readMode;
    uint8_t writeMode;
    uint32_t readSpeed;
    uint32_t writeSpeed;
} tclspi_clientData;

