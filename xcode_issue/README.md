# Demonstrator #

CI is performed on macOS 13 and the latest stable Xcode (15), which
introduced the problem with the new ld and ld-classic. The main effect
seen with this is sometimes-failing exception handling.

The job steps are
- Report the installed `ld`
- Install the latest stable _Xcode_
- Report the new version of `ld`
- Checkout
- Set up Alire
- Install the toolchain
- Build and run, showing errors
- Apply the code fix
- Relink and run, without errors.
