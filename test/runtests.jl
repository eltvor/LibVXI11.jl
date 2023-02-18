using LibVXI11
using Test

@testset "LibVXI11.jl" begin
    # check the basic ccall-ability of libvxi11 by querying lib version
    v_maj,v_min,v_rev,v_id = vxi_lib_version()
    @test v_maj*1000000+v_min*1000+v_rev == v_id

    # to test any other functionality, we would need to run a dummy RPC server
    # not (yet) incorporated
end
