# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Openssl::Md5() { openssl md5 $@ 2>&- | awk -F '= ' '{print $2 ; exit}' ; }

Openssl::Sha1() { openssl sha1 $@ 2>&- | awk -F '= ' '{print $2 ; exit}' ; }

Openssl::Sha256() { openssl sha256 $@ 2>&- | awk -F '= ' '{print $2 ; exit}' ; }

Openssl::Sha512() { openssl sha512 $@ 2>&- | awk -F '= ' '{print $2 ; exit}' ; }
