/*
 * Spi_Init and Spi_SafeInit
 *
 * Copyright (C) 2013 - 2014 Karl Lehenbauer, All Rights Reserved
 *
 * Freely redistributable under the Berkeley copyright.  See license.terms
 * for details.
 */

#include <tcl.h>
#include "tclspi.h"

#undef TCL_STORAGE_CLASS
#define TCL_STORAGE_CLASS DLLEXPORT


/*
 *----------------------------------------------------------------------
 *
 * Spi_Init --
 *
 *	Initialize the spi extension.  The string "spi" 
 *      in the function name must match the PACKAGE declaration at the top of
 *	configure.in.
 *
 * Results:
 *	A standard Tcl result
 *
 * Side effects:
 *	One new command "spi" is added to the Tcl interpreter.
 *
 *----------------------------------------------------------------------
 */

EXTERN int
Spi_Init(Tcl_Interp *interp)
{
    /*
     * This may work with 8.0, but we are using strictly stubs here,
     * which requires 8.1.
     */
    if (Tcl_InitStubs(interp, "8.1", 0) == NULL) {
	return TCL_ERROR;
    }

    if (Tcl_PkgRequire(interp, "Tcl", "8.1", 0) == NULL) {
	return TCL_ERROR;
    }

    if (Tcl_PkgProvide(interp, "spi", PACKAGE_VERSION) != TCL_OK) {
	return TCL_ERROR;
    }

    /* Create the spi command  */
    Tcl_CreateObjCommand(interp, "spi", (Tcl_ObjCmdProc *) tclspi_spiObjCmd, (ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

    return TCL_OK;
}


/*
 *----------------------------------------------------------------------
 *
 * Spi_SafeInit --
 *
 *	Initialize the spi extension in a safe interpreter.
 *
 *      This should be totally safe.
 *
 * Results:
 *	A standard Tcl result
 *
 * Side effects:
 *	One new command "spi" is added to the Tcl interpreter.
 *
 *----------------------------------------------------------------------
 */

EXTERN int
Spi_SafeInit(Tcl_Interp *interp)
{
    /*
     * This may work with 8.0, but we are using strictly stubs here,
     * which requires 8.1.
     */
    if (Tcl_InitStubs(interp, "8.1", 0) == NULL) {
	return TCL_ERROR;
    }

    if (Tcl_PkgRequire(interp, "Tcl", "8.1", 0) == NULL) {
	return TCL_ERROR;
    }

    if (Tcl_PkgProvide(interp, "spi", PACKAGE_VERSION) != TCL_OK) {
	return TCL_ERROR;
    }

    /* Create the spi command  */
    Tcl_CreateObjCommand(interp, "spi", (Tcl_ObjCmdProc *) tclspi_spiObjCmd, (ClientData)NULL, (Tcl_CmdDeleteProc *)NULL);

    return TCL_OK;
}

