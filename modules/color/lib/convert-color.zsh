# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function ColorConvert {

  # ColorConvert <256-color-code> <terminal-supported-colors>

  # Catch errors
  case ${1} in
    [0-9]|[1-9][0-9]|[1-2][0-4][0-9]|25[0-6]|256)
      true
      ;;
    *)
      ErrError "not a valid color code: ${1}"
      return 1
      ;;
  esac
  case ${2} in
    8|16|88|256)
      true
      ;;
    *)
      ErrError "not a valid terminal color set: ${1}"
      return 1
      ;;
  esac

  case ${1} in
    0)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    1)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    2)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    3)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    4)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    5)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    6)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    7)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    8)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    9)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    10)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    11)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    12)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    13)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    14)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    15)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    16)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    17)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    18)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    19)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    20)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    21)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    22)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    23)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    24)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    25)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    26)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    27)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    28)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    29)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    30)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    31)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    32)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    33)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    34)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    35)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    36)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    37)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    38)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    39)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    40)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    41)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    42)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    43)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    44)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    45)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    46)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    47)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    48)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    49)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    50)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    51)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    52)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    53)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    54)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    55)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    56)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    57)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    58)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    59)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    60)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    61)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    62)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    63)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    64)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    65)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    66)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    67)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    68)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    69)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    70)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    71)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    72)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    73)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    74)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    75)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    76)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    77)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    78)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    79)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    80)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    81)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    82)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    83)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    84)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    85)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    86)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    87)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    88)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    89)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    90)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    91)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    92)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    93)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    94)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    95)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    96)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    97)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    98)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    99)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    100)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    101)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    102)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    103)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    104)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    105)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    106)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    107)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    108)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    109)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    110)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    111)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    112)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    113)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    114)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    115)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    116)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    117)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    118)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    119)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    120)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    121)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    122)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    123)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    124)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    125)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    126)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    127)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    128)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    129)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    130)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    131)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    132)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    133)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    134)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    135)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    136)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    137)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    138)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    139)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    140)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    141)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    142)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    143)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    144)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    145)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    146)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    147)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    148)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    149)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    150)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    151)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    152)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    153)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    154)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    155)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    156)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    157)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    158)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    159)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    160)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    161)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    162)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    163)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    164)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    165)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    166)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    167)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    168)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    169)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    170)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    171)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    172)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    173)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    174)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    175)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    176)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    177)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    178)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    179)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    180)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    181)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    182)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    183)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    184)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    185)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    186)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    187)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    188)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    189)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    190)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    191)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    192)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    193)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    194)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    195)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    196)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    197)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    198)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    199)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    200)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    201)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    202)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    203)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    204)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    205)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    206)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    207)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    208)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    209)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    210)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    211)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    212)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    213)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    214)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    215)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    215)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    217)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    218)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    219)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    220)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    221)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    222)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    223)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    224)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    225)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    226)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    227)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    228)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    229)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    230)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    231)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    232)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    234)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    235)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    236)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    237)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    238)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    239)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    240)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    241)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    242)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    243)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    244)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    245)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    246)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    247)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    248)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    249)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    250)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    251)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    252)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    253)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    254)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    255)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;
    256)
      case ${2} in
        8) echo x ;;
        16) echo x ;;
        88) echo x ;;
        256) echo ${1} ;;
      esac
      ;;

  esac

  return 0

}
