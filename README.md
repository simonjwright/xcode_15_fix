Some issues arose with macOS's Xcode/Command Line Tools version 15. The obvious one was that programs wouldn't link! A less obvious one was that Ada exception handling was unreliable (some exceptions would be caught, others not).

Apple provided a "classic" linker in the version 15 SDKs, `ld-classic`, which has the old `ld`'s behaviour. You can invoke this by giving `ld` the switch `-ld_classic` (this switch isn't available in the `ld` in the pre-15 SDKs, which interpret it as requesting a library `libd_classic.a`). The version 15.1 beta releases will link even without the `-ld_classic` switch.

Unfortunately, this didn't resolve the exception handling problem.

It turns out that linking with `ld-classic` also resolves the exception handling issue, though this can hardly have been Apple's intention.

It's easy to forget to invoke `ld-classic`, so we've provided a shim to invoke it instead of `ld` if it's available.

We want to install our ld shim where the compiler will look for it. The first place it looks (see `--with-as=pathname` in [the GCC Configuration documentation](https://gcc.gnu.org/install/configure.html)) is <code>libexec/gcc/<i>target</i>/<i>version</i></code>. This is the place where `gcc` keeps the actual compiler executables (`gcc` itself is a driver), such as `cc1`, `gnat1`; our task is to place an executable object (e.g. a script) named `ld` there, whose task is to check whether `ld-classic` is present; if so, invoke it, if not, invoke `ld`.

To install: in a shell where your `gcc` is first on the `PATH`,
```
sh install-ld-shim.sh
```
or, if you're running Alire,
```
alr exec -- sh install-ld-shim.sh
```

Note, depending on how your compiler was installed you may need to use `sudo`.
