# QKDNetSim

**Requirements:** Ubuntu 22.04, GCC, CMake, Python 3, Crypto++, ns-3.48. Linux workstation or VM.

```bash
sudo apt-get install -y gcc g++ python3 python3-dev cmake
git clone -b ns-3.48 https://gitlab.com/nsnam/ns-3-dev.git && cd ns-3-dev
cd contrib && git clone -b master https://github.com/QKDNetSim/qkdnetsim.git && cd ..
git apply --check contrib/qkdnetsim/patches/gnuplot_cc.patches
git apply contrib/qkdnetsim/patches/gnuplot_h.patches
git apply contrib/qkdnetsim/patches/gnuplot_cc.patches
./ns3 configure --enable-mpi --enable-examples
./ns3 run examples_qkdnetsim_etsi_014
```

## Known issues

- Only ns-3.48 is supported.
- Tested by the authors on Ubuntu 22.04 only.
- Apply the patches on a clean ns-3 clone.
