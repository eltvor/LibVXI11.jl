module LibVXI11

export VXI11_CLINK
export vxi_lib_version
export vxi_open_device, vxi_close_device
export vxi_send, vxi_receive, vxi_receive_s

mutable struct VXI11_CLINK
end

function vxi_lib_version()
    #int vxi11_lib_version(int *major, int *minor, int *revision);
    major=Ref{Cint}(0)
    minor=Ref{Cint}(0)
    revision=Ref{Cint}(0)
    version_id = ccall((:vxi11_lib_version, "libvxi11"), Cint,
                       (Ref{Cint}, Ref{Cint}, Ref{Cint},),
                       major, minor, revision)
    return major[], minor[], revision[], version_id
end

function vxi_open_device(address::String; device::String = "")
    # int vxi11_open_device(VXI11_CLINK **clink, const char *address, char *device);
    dev_s = (length(device) == 0) ? C_NULL : device
    clink_p = Ref{Ptr{VXI11_CLINK}}(0)
    rc = ccall((:vxi11_open_device, "libvxi11"), Cint,
  	       (Ref{Ptr{VXI11_CLINK}}, Cstring, Cstring,),
               clink_p, address, dev_s)
    return (rc == 0) ? clink_p[] : C_NULL
end

function vxi_close_device(clink::Ptr{VXI11_CLINK}, address::String)
    # int vxi11_close_device(VXI11_CLINK *clink, const char *address);
    return ccall((:vxi11_close_device, "libvxi11"), Cint,
  	         (Ptr{VXI11_CLINK}, Cstring,),
                 clink, address)
end

function vxi_send(clink::Ptr{VXI11_CLINK}, cmd::Vector{UInt8})
    # int vxi11_send(VXI11_CLINK *clink, const char *cmd, size_t len);
    return ccall((:vxi11_send, "libvxi11"), Cint,
                 (Ptr{VXI11_CLINK}, Ref{UInt8}, Csize_t,),
                 clink, cmd, length(cmd))
end

function vxi_send(clink::Ptr{VXI11_CLINK}, cmd::String)
    return vxi_send(clink, Vector{UInt8}(cmd))
end

function vxi_receive(clink::Ptr{VXI11_CLINK}, buffer::Vector{UInt8})
    # ssize_t vxi11_receive(VXI11_CLINK *clink, char *buffer, size_t len);
    rc = ccall((:vxi11_receive, "libvxi11"), Cssize_t,
               (Ptr{VXI11_CLINK}, Ref{UInt8}, Csize_t,),
               clink, buffer, length(buffer))
    if rc < 0
        return Int(-rc), 0
    else
        return 0, rc
    end
end

function vxi_receive(clink::Ptr{VXI11_CLINK}; max_len::Int64 = 256)
    buffer = Vector{UInt8}(undef, max_len)
    rc, len = vxi_receive(clink, buffer)
    if rc != 0
        return nothing
    else
        return buffer[1:len]
    end
end

function vxi_receive_s(clink::Ptr{VXI11_CLINK}; max_len::Int64 = 256)
    bs = vxi_receive(clink, max_len = max_len)
    if bs == nothing
        return nothing
    else
        return String(bs)
    end
end

# ssize_t vxi11_receive_timeout(VXI11_CLINK *clink, char *buffer, size_t len, unsigned long timeout);
# int vxi11_send_data_block(VXI11_CLINK *clink, const char *cmd, char *buffer, size_t len);
# ssize_t vxi11_receive_data_block(VXI11_CLINK *clink, char *buffer, size_t len, unsigned long timeout);
# int vxi11_send_and_receive(VXI11_CLINK *clink, const char *cmd, char *buf, size_t len, unsigned long timeout);

end
