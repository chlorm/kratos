# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

if path_hasbin "yum" ; then
  alias yumc='sudo yum clean all' # Cleans the cache.
  alias yumh='yum history'        # Displays history.
  alias yumi='sudo yum install'   # Installs package(s).
  alias yuml='yum list'           # Lists packages.
  alias yumL='yum list installed' # Lists installed packages.
  alias yumq='yum info'           # Displays package information.
  alias yumr='sudo yum remove'    # Removes package(s).
  alias yums='yum search'         # Searches for a package.
  alias yumu='sudo yum update'    # Updates packages.
  alias yumU='sudo yum upgrade'   # Upgrades packages.
fi