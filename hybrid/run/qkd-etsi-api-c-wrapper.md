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
