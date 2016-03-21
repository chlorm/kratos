=====
btrfs
=====

Aliases
=======

btrfs-defrag
------------
   * Usage
      .. code-block:: shell

         $ btrfs-defrag <path>

   * Actual command

      .. code-block:: shell

         $ ~sudo~ btrfs filesystem defragment -r -v -clzo <path>

btrfs-errors
------------
   * Usage
      .. code-block:: shell

         $ btrfs-errors

   * Actual command

      .. code-block:: shell

         dmesg | grep "checksum error at"

btrfs-scrub
------------
   * Usage
      .. code-block:: shell

         $ btrfs-scrub <path>

   * Actual command

      .. code-block:: shell

         $ ~sudo~ btrfs scrub start -c3 -n7 <path>

btrfs-status
------------
   * Usage
      .. code-block:: shell

         $ btrfs-status <path>

   * Actual command

      .. code-block:: shell

         $ ~sudo~ btrfs scrub status <path>
