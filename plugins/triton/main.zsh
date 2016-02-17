# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function triton_clear_env {
  # Clear environment variables in user environment used
  # by Triton's makeWrapper.

  unset GDK_PIXBUF_MODULE_FILE
  unset GI_TYPELIB_PATH
  unset GIO_EXTRA_MODULES
  unset GRL_PLUGIN_PATH
  unset GST_PLUGIN_SYSTEM_PATH_1_0
  unset GSETTINGS_SCHEMAS_PATH
  unset XDG_DATA_DIRS
  unset XDG_ICON_DIRS
}
