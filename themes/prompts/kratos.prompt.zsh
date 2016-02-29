# This file is part of Kratos.
# Copyright (c) 2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

if [[ -n "${SSH_CLIENT}" ]] ; then
  KratosPromptSsh='f10'
else
  KratosPromptSsh='f16'
fi

KRATOS_PROMPT_1='$(kprmt f11)%n$(kprmt bold)$(kprmt f1)@$(kprmt bold)$(kprmt ${KratosPromptSsh})%M$(kprmt f1)[$(kprmt reset)$(kprmt f2)%~$(kprmt bold)$(kprmt f1)]$(kprmt f7)〉$(kprmt reset)'
KRATOS_PROMPT_2=''
KRATOS_PROMPT_3=''
KRATOS_PROMPT_4=''
KRATOS_RPROMPT_1='$(KRATOS::Modules:prompt.vcs)'
KRATOS_RPROMPT_2=''