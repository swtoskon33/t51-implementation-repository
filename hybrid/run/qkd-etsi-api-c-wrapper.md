# qkd-etsi-api-c-wrapper (UC3M)

**Requirements:** C compiler, CMake, OpenSSL development libraries.
**Requires testbed (hardware mode only):** a pair of IDQ Cerberis XGR devices with their KME certificates.

```bash
git clone https://github.com/qursa-uc3m/qkd-etsi-api-c-wrapper && cd qkd-etsi-api-c-wrapper
mkdir build && cd build
cmake -DENABLE_ETSI004=ON -DENABLE_ETSI014=ON -DQKD_BACKEND=simulated -DBUILD_TESTS=ON ..
make
./etsi014_test
# hardware mode:
# cmake -DENABLE_ETSI014=ON -DQKD_BACKEND=cerberis_xgr .. && make && ./etsi014_full_test
```

## Known issues

- The back-end is selected at compile time.
- The full ETSI 014 test runs only with hardware back-ends.
- With ETSI 014 and the simulated back-end, the build requires the libuuid library, which is not listed in the dependencies. Install it (for example `uuid-dev` or `util-linux`) and pass its path with `-DUUID_LIB` if it is not found automatically.

## Validation

Tested on 04/10/2026 with the simulated back-end. The library built with ETSI 004 and ETSI 014 enabled, and both test programs (`etsi004_test` and `etsi014_test`) passed. Hardware mode with IDQ Cerberis XGR devices remains to be tested in a testbed.
