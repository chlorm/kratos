# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

KRATOS::Plugins:openssl.md5() {
  openssl md5 $@ | awk -F '= ' '{print $2}'
}

KRATOS::Plugins:openssl.sha1() {
  openssl sha1 $@ | awk -F '= ' '{print $2}'
}

KRATOS::Plugins:openssl.sha256() {
  openssl sha256 $@ | awk -F '= ' '{print $2}'
}

KRATOS::Plugins:openssl.sha512() {
  openssl sha512 $@ | awk -F '= ' '{print $2}'
}
