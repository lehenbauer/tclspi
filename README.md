### This is tclspi, a direct Tcl interface to the Serial Peripheral Interface Bus on the Raspberry Pi.

*Version 1.0*

This package is a freely available open source package under the "Berkeley" license, same as Tcl.  You can do virtually anything you like with it, such as modifying it, redistributing it, and selling it either in whole or in part. See the file "license.terms" for complete information.

tclspi was written by Karl Lehenbauer.  

Using tclspi
-----------

```tcl
package require spi
```

Example
===========

```package require spi

set spi [spi #auto /dev/spidev0.0]

$spi read_mode 0
$spi write_mode 0
$spi write_bits_word 8
$spi read_bits_word 8
$spi write_maxspeed 500000
$spi read_maxspeed 500000

set transmitString "heya_kids_heya_heya_heya"

set receiveString [$spi transfer $transmitString 50]

puts "sent: $transmitString"
puts "recd: $receiveString"

$spi delete
```

Contents
========

```Makefile.in```	Makefile template.  The configure script uses this file to
		produce the final Makefile.

```README```	This file

```aclocal.m4```	Generated file.  Do not edit.  Autoconf uses this as input
		when generating the final configure script.  See "tcl.m4"
		below.

```configure```	Generated file.  Do not edit.  This must be regenerated
		anytime configure.in or tclconfig/tcl.m4 changes.

```configure.in```	Configure script template.  Autoconf uses this file as input
		to produce the final configure script.

```generic/tclspi.c```	SPI interface routines.
```generic/tclspi.h```	include file
```generic/tclspitcl.c```	Init routines.


```tclconfig/```	This directory contains various template files that build
		the configure script.  They should not need modification.

```install-sh```	Program used for copying binaries and script files
		to their install locations.

```tcl.m4```		Collection of Tcl autoconf macros.  Included by
		aclocal.m4 to define SC_* macros.

Building
==========

Unix
----------

Building under most UNIX systems is easy, just run the configure script
and then run make. 

```bash
$ cd tclspi
$ ./configure
$ make
$ make install
```

Windows
----------

tclspi has not been built under Windows at this time.

The recommended method to build extensions under Windows is to use the Msys + Mingw build process. This provides a Unix-style build while generating native Windows binaries. Using the Msys + Mingw build tools means that you can use the same configure script as per the Unix build to create a Makefile.

If you have VC++, then you may wish to use the files in the win subdirectory and build the extension using just VC++. 

Instructions for using the VC++ makefile are written in the first part of the Makefile.vc file.

Installation
============

```bash
make install
```

tclspi installs like so:

```
         $exec_prefix
          /       \
        lib       bin
         |         |
   PACKAGEx.y   (dependent .dll files on Windows)
         |
  pkgIndex.tcl (.so|.dll files)
```

The main ```.so|.dll``` library file gets installed in the versioned ```PACKAGE``` directory, which is OK on all platforms because it will be directly referenced with by 'load' in the ```pkgIndex.tcl``` file.  Dependent DLL files on Windows must go in the bin directory (or other directory on the user's PATH) in order for them to be found.

tclspi has not been tested with Windows so none of the above may be true.

