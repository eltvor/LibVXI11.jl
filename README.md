# LibVXI11

## Description
- lightweight VXI11 instrument control from Julia
- tiny `ccall` wrapper around `libvxi11.so`
- (intentionally) no higher-level layers such as NI VISA

## Redistribution and licensing
The provided code and license covers only the `LibVXI11.jl` wrapper, not the shared library `libvxi11.so`, which is licensed under its own mix of GNU GPLv2 and a special license for the `.x` RPC source file.

## Usage
```
dev = vxi_open_device("192.168.0.10")
vxi_send(dev, "*idn?")
vxi_receive_s(dev)
vxi_close_device(dev, "192.168.0.10")
```
- `vxi_send` takes either String or byte vector
- `vxi_receive` can output either to a pre-allocated buffer, or allocate one a temporary buffer (optionally provide `max_len` if 256 is not enough)
- `vxi_receive_s` is a convenience call returning String

## TODO
- add binary dependency build
- change the device handle to a Julia struct holding server address, allowing for a simpler `vxi_close_device(dev)` call
- support (optional) timeouted calls
- benchmark against Keno/VXI11.jl
- if you wish to test the whole functionality, a dummy RPC server shall be run to perform queries -- unsure if it is worth doing so, as this wrapper does not actually implement anything than ccalling the lib

## ChangeLog
- ported to Julia-1.0 on the request of Jakub Ladman, tested with Julia-1.8, bugfixes (`Ptr{}` -> `Ref{}`) (Feb 2023)
- initial working versions, Julia-0.4.6 and Julia-0.6.4 (Jan 2019)

## Heritage and results
- written ~2019 to support huge data dumps from HP/Agilent/Keysight Infiniium oscilloscopes on the floor of the European Space Agency, as well as during 2020 COMPASS tokamak plasma inteferometer design and experiment
- mid-age Infiniium 50Gsps oscilloscope --> ThinkPad T420s transfer over 1000BaseTx and TCP yielded some net rate of ~320Mbps (no jumbo buffers in place, WinXP running on the oscilloscope)

## Credits
- Steve D. Sharples (author of the libvxi11.so)
  - Applied Optics Group, Nottingham http://optics.eee.nottingham.ac.uk/
- [Jakub Ladman](https://github.com/ladmanj) (inspiring me to publish and initial 2nd user)

## See also
- the original [libvxi11 library](https://github.com/ladmanj) we call, and its [homepage](http://optics.eee.nottingham.ac.uk/vxi11/)
- different projects with similar goal:
    * [Keno/VXI11.jl](https://github.com/Keno/VXI11.jl) - pure Julia implementation of the VXI11's RPC. Seems to lack the RPC-portmapper, so the instrument name to TCP port resolution is not possible
    * [Instruments.jl](https://instrumentsjl.readthedocs.io/)

