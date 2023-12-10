# Some issues arose with macOS's Xcode/Command Line Tools version
# 15. The obvious one was that programs wouldn't link! A less obvious
# one was that Ada exception handling was unreliable (some exceptions
# would be caught, others not).
#
# Apple provided a "classic" linker in the version 15 SDK,
# 'ld-classic', which has the old ld's behaviour. You can invoke this
# by giving 'ld' the switch '-ld_classic' (this switch isn't available
# in the 'ld' in the pre-15 SDKs, which interpret it as requesting a
# library 'libd_classic.a').
#
# It turns out that linking with 'ld-classic' also resolves the
# exception handling issue.
#
# It's easy to forget to invoke 'ld-classic', so we've provided a shim
# to invoke it instead of 'ld' if it's available.
#
# We want to install our ld shim where the compiler will look for
# it. The first place it looks (see "--with-as=pathname in
# https://gcc.gnu.org/install/configure.html) is
# libexec/gcc/target/version. This is the place where gcc keeps the
# actual compiler executables (gcc itself is a driver), such as cc1,
# gnat1.

# Find the full path name for the C compiler's location
tool_path=$(dirname $(gcc --print-prog-name=cc1))
echo "Installing in $tool_path"

# Write our shim there. If we're running a pre-15 SDK, there won't be
# an ld-classic, so use the standard linker.
#
# Need to keep a lookout for SDKs version > 15.
cat >$tool_path/ld <<EOF
#!/bin/sh

classic=$(xcrun --find ld-classic 2>/dev/null) || true

if [ -n "$classic" ]; then
    exec $classic "$@"
else
    exec ld "$@"
fi

EOF

# It needs to be executable!
chmod +x $tool_path/ld
