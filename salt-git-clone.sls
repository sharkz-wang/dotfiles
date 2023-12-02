bash:
    git.detached:
        - name: https://git.savannah.gnu.org/git/bash.git
        - target: /home/master/02/r02922070/tmpfs/src/bash
        - rev: bash-5.0

busybox:
    git.detached:
        - name: git://busybox.net/busybox.git
        - target: /home/master/02/r02922070/tmpfs/src/busybox
#       salt recognized this tag as commit id and lead to error
#       - rev: 1_31_0
        - rev: 0f1369f

coreutils:
    git.detached:
        - name: https://git.savannah.gnu.org/git/coreutils.git
        - target: /home/master/02/r02922070/tmpfs/src/coreutils
        - rev: v8.31

glibc:
    archive.extracted:
        - name: /home/master/02/r02922070/tmpfs/src/
        - source: http://ftp.gnu.org/gnu/glibc/glibc-2.29.tar.xz
        - source_hash: f3eeb8d57e25ca9fc13c2af3dae97754f9f643bc69229546828e3a240e2af04b

kmod:
    git.detached:
        - name: https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git
        - target: /home/master/02/r02922070/tmpfs/src/kmod
        - rev: v26

linux:
    git.detached:
        - name: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
        - target: /home/master/02/r02922070/tmpfs/src/linux
#       revision: v4.9.92
        - rev: v4.9.92

qemu:
    git.detached:
        - name: https://git.qemu.org/git/qemu.git
        - target: /home/master/02/r02922070/tmpfs/src/qemu
        - rev: v3.0.1

grub:
    git.detached:
        - name: https://git.savannah.gnu.org/git/grub.git
        - target: /home/master/02/r02922070/tmpfs/src/grub
        - rev: grub-2.04

systemd:
    git.detached:
        - name: https://github.com/systemd/systemd
        - target: /home/master/02/r02922070/tmpfs/src/systemd
        - rev: v242

upstart:
    archive.extracted:
        - name: /home/master/02/r02922070/tmpfs/src/
        - source: http://upstart.ubuntu.com/download/1.13.2/upstart-1.13.2.tar.gz
        - source_hash: 460183e3dd1dab9986cb9433ba5287684cf6eedd44afbebc13455566957ca3c0
