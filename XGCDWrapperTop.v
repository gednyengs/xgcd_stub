//-----------------------------------------------------------------------------
// Verilog 2001 (IEEE Std 1364-2001)
//-----------------------------------------------------------------------------
// Purpose: Dummy XGCD Wrapper
//------------------------------------------------------------------------------
//
// Author   : Gedeon Nyengele
// Date     : Aug 30, 2022
//------------------------------------------------------------------------------

module XGCDWrapperTop (
    input       wire            clk_in_extern,
    input       wire            clk_in_system,
    input       wire            reset_n,
    input       wire [1:0]      clk_select,
    output      wire            clk_div_8,

    output      wire            start_out_255,
    output      wire            start_out_1279,
    output      wire            done_out_255,
    output      wire            done_out_1279,

    output      wire            IRQ_255,
    output      wire            IRQ_1279,

    input       wire [31:0]     S_APB_PADDR_RO,
    input       wire            S_APB_PSEL_RO,
    input       wire            S_APB_PENABLE_RO,
    input       wire            S_APB_PWRITE_RO,
    input       wire [31:0]     S_APB_PWDATA_RO,
    output      wire [31:0]     S_APB_PRDATA_RO,
    output      wire            S_APB_PREADY_RO,
    output      wire            S_APB_PSLVERR_RO,

    input       wire [31:0]     S_APB_PADDR_255,
    input       wire            S_APB_PSEL_255,
    input       wire            S_APB_PENABLE_255,
    input       wire            S_APB_PWRITE_255,
    input       wire [31:0]     S_APB_PWDATA_255,
    output      wire [31:0]     S_APB_PRDATA_255,
    output      wire            S_APB_PREADY_255,
    output      wire            S_APB_PSLVERR_255,

    input       wire [31:0]     S_APB_PADDR_1279,
    input       wire            S_APB_PSEL_1279,
    input       wire            S_APB_PENABLE_1279,
    input       wire            S_APB_PWRITE_1279,
    input       wire [31:0]     S_APB_PWDATA_1279,
    output      wire [31:0]     S_APB_PRDATA_1279,
    output      wire            S_APB_PREADY_1279,
    output      wire            S_APB_PSLVERR_1279,

    input       wire [3:0]      S_AXI_AWID_255,
    input       wire [31:0]     S_AXI_AWADDR_255,
    input       wire [7:0]      S_AXI_AWLEN_255,
    input       wire [2:0]      S_AXI_AWSIZE_255,
    input       wire [1:0]      S_AXI_AWBURST_255,
    input       wire            S_AXI_AWLOCK_255,
    input       wire [3:0]      S_AXI_AWCACHE_255,
    input       wire [2:0]      S_AXI_AWPROT_255,
    input       wire            S_AXI_AWVALID_255,
    output      wire            S_AXI_AWREADY_255,
    input       wire [63:0]     S_AXI_WDATA_255,
    input       wire [7:0]      S_AXI_WSTRB_255,
    input       wire            S_AXI_WLAST_255,
    input       wire            S_AXI_WVALID_255,
    output      wire            S_AXI_WREADY_255,
    output      wire [3:0]      S_AXI_BID_255,
    output      wire [1:0]      S_AXI_BRESP_255,
    output      wire            S_AXI_BVALID_255,
    input       wire            S_AXI_BREADY_255,
    input       wire [3:0]      S_AXI_ARID_255,
    input       wire [31:0]     S_AXI_ARADDR_255,
    input       wire [7:0]      S_AXI_ARLEN_255,
    input       wire [2:0]      S_AXI_ARSIZE_255,
    input       wire [1:0]      S_AXI_ARBURST_255,
    input       wire            S_AXI_ARLOCK_255,
    input       wire [3:0]      S_AXI_ARCACHE_255,
    input       wire [2:0]      S_AXI_ARPROT_255,
    input       wire            S_AXI_ARVALID_255,
    output      wire            S_AXI_ARREADY_255,
    output      wire [3:0]      S_AXI_RID_255,
    output      wire [63:0]     S_AXI_RDATA_255,
    output      wire [1:0]      S_AXI_RRESP_255,
    output      wire            S_AXI_RLAST_255,
    output      wire            S_AXI_RVALID_255,
    input       wire            S_AXI_RREADY_255,

    input       wire [3:0]      S_AXI_AWID_1279,
    input       wire [31:0]     S_AXI_AWADDR_1279,
    input       wire [7:0]      S_AXI_AWLEN_1279,
    input       wire [2:0]      S_AXI_AWSIZE_1279,
    input       wire [1:0]      S_AXI_AWBURST_1279,
    input       wire            S_AXI_AWLOCK_1279,
    input       wire [3:0]      S_AXI_AWCACHE_1279,
    input       wire [2:0]      S_AXI_AWPROT_1279,
    input       wire            S_AXI_AWVALID_1279,
    output      wire            S_AXI_AWREADY_1279,
    input       wire [63:0]     S_AXI_WDATA_1279,
    input       wire [7:0]      S_AXI_WSTRB_1279,
    input       wire            S_AXI_WLAST_1279,
    input       wire            S_AXI_WVALID_1279,
    output      wire            S_AXI_WREADY_1279,
    output      wire [3:0]      S_AXI_BID_1279,
    output      wire [1:0]      S_AXI_BRESP_1279,
    output      wire            S_AXI_BVALID_1279,
    input       wire            S_AXI_BREADY_1279,
    input       wire [3:0]      S_AXI_ARID_1279,
    input       wire [31:0]     S_AXI_ARADDR_1279,
    input       wire [7:0]      S_AXI_ARLEN_1279,
    input       wire [2:0]      S_AXI_ARSIZE_1279,
    input       wire [1:0]      S_AXI_ARBURST_1279,
    input       wire            S_AXI_ARLOCK_1279,
    input       wire [3:0]      S_AXI_ARCACHE_1279,
    input       wire [2:0]      S_AXI_ARPROT_1279,
    input       wire            S_AXI_ARVALID_1279,
    output      wire            S_AXI_ARREADY_1279,
    output      wire [3:0]      S_AXI_RID_1279,
    output      wire [63:0]     S_AXI_RDATA_1279,
    output      wire [1:0]      S_AXI_RRESP_1279,
    output      wire            S_AXI_RLAST_1279,
    output      wire            S_AXI_RVALID_1279,
    input       wire            S_AXI_RREADY_1279
);

    //
    // Internal Signals
    //

    wire                        CLK;
    wire                        RESETn;

    //
    // Clock And Reset Module
    //

    ClockAndReset u_clk_reset (
        .EXT_CLK                (clk_in_extern),
        .SYS_CLK                (clk_in_system),
        .CLK_SEL                (clk_select),
        .PORESETn               (reset_n),
        .CLK                    (CLK),
        .RESETn                 (RESETn)
    );

    assign clk_div_8            = CLK;

    //
    // RO APB
    //

    RO u_ro_apb (
        .CLK                    (CLK),
        .RESETn                 (RESETn),

        .PADDR                  (S_APB_PADDR_RO),
        .PSEL                   (S_APB_PSEL_RO),
        .PENABLE                (S_APB_PENABLE_RO),
        .PWRITE                 (S_APB_PWRITE_RO),
        .PWDATA                 (S_APB_PWDATA_RO),
        .PRDATA                 (S_APB_PRDATA_RO),
        .PREADY                 (S_APB_PREADY_RO),
        .PSLVERR                (S_APB_PSLVERR_RO)
    );

    //
    // XGCD_255
    //

    XGCDCore #(.WIDTH(255)) u_xgcd_255 (
        .CLK                    (CLK),
        .RESETn                 (RESETn),

        .PADDR                  (S_APB_PADDR_255),
        .PSEL                   (S_APB_PSEL_255),
        .PENABLE                (S_APB_PENABLE_255),
        .PWRITE                 (S_APB_PWRITE_255),
        .PWDATA                 (S_APB_PWDATA_255),
        .PRDATA                 (S_APB_PRDATA_255),
        .PREADY                 (S_APB_PREADY_255),
        .PSLVERR                (S_APB_PSLVERR_255),

        .AWID                   (S_AXI_AWID_255),
        .AWADDR                 (S_AXI_AWADDR_255),
        .AWLEN                  (S_AXI_AWLEN_255),
        .AWSIZE                 (S_AXI_AWSIZE_255),
        .AWBURST                (S_AXI_AWBURST_255),
        .AWLOCK                 (S_AXI_AWLOCK_255),
        .AWCACHE                (S_AXI_AWCACHE_255),
        .AWPROT                 (S_AXI_AWPROT_255),
        .AWVALID                (S_AXI_AWVALID_255),
        .AWREADY                (S_AXI_AWREADY_255),
        .WDATA                  (S_AXI_WDATA_255),
        .WSTRB                  (S_AXI_WSTRB_255),
        .WLAST                  (S_AXI_WLAST_255),
        .WVALID                 (S_AXI_WVALID_255),
        .WREADY                 (S_AXI_WREADY_255),
        .BID                    (S_AXI_BID_255),
        .BRESP                  (S_AXI_BRESP_255),
        .BVALID                 (S_AXI_BVALID_255),
        .BREADY                 (S_AXI_BREADY_255),
        .ARID                   (S_AXI_ARID_255),
        .ARADDR                 (S_AXI_ARADDR_255),
        .ARLEN                  (S_AXI_ARLEN_255),
        .ARSIZE                 (S_AXI_ARSIZE_255),
        .ARBURST                (S_AXI_ARBURST_255),
        .ARLOCK                 (S_AXI_ARLOCK_255),
        .ARCACHE                (S_AXI_ARCACHE_255),
        .ARPROT                 (S_AXI_ARPROT_255),
        .ARVALID                (S_AXI_ARVALID_255),
        .ARREADY                (S_AXI_ARREADY_255),
        .RID                    (S_AXI_RID_255),
        .RDATA                  (S_AXI_RDATA_255),
        .RRESP                  (S_AXI_RRESP_255),
        .RLAST                  (S_AXI_RLAST_255),
        .RVALID                 (S_AXI_RVALID_255),
        .RREADY                 (S_AXI_RREADY_255),

        .IRQ                    (IRQ_255),
        .START_OUT              (start_out_255),
        .DONE_OUT               (done_out_255)
    );

    //
    // XGCD_1279
    //

    XGCDCore #(.WIDTH(1279)) u_xgcd_1279 (
        .CLK                    (CLK),
        .RESETn                 (RESETn),

        .PADDR                  (S_APB_PADDR_1279),
        .PSEL                   (S_APB_PSEL_1279),
        .PENABLE                (S_APB_PENABLE_1279),
        .PWRITE                 (S_APB_PWRITE_1279),
        .PWDATA                 (S_APB_PWDATA_1279),
        .PRDATA                 (S_APB_PRDATA_1279),
        .PREADY                 (S_APB_PREADY_1279),
        .PSLVERR                (S_APB_PSLVERR_1279),

        .AWID                   (S_AXI_AWID_1279),
        .AWADDR                 (S_AXI_AWADDR_1279),
        .AWLEN                  (S_AXI_AWLEN_1279),
        .AWSIZE                 (S_AXI_AWSIZE_1279),
        .AWBURST                (S_AXI_AWBURST_1279),
        .AWLOCK                 (S_AXI_AWLOCK_1279),
        .AWCACHE                (S_AXI_AWCACHE_1279),
        .AWPROT                 (S_AXI_AWPROT_1279),
        .AWVALID                (S_AXI_AWVALID_1279),
        .AWREADY                (S_AXI_AWREADY_1279),
        .WDATA                  (S_AXI_WDATA_1279),
        .WSTRB                  (S_AXI_WSTRB_1279),
        .WLAST                  (S_AXI_WLAST_1279),
        .WVALID                 (S_AXI_WVALID_1279),
        .WREADY                 (S_AXI_WREADY_1279),
        .BID                    (S_AXI_BID_1279),
        .BRESP                  (S_AXI_BRESP_1279),
        .BVALID                 (S_AXI_BVALID_1279),
        .BREADY                 (S_AXI_BREADY_1279),
        .ARID                   (S_AXI_ARID_1279),
        .ARADDR                 (S_AXI_ARADDR_1279),
        .ARLEN                  (S_AXI_ARLEN_1279),
        .ARSIZE                 (S_AXI_ARSIZE_1279),
        .ARBURST                (S_AXI_ARBURST_1279),
        .ARLOCK                 (S_AXI_ARLOCK_1279),
        .ARCACHE                (S_AXI_ARCACHE_1279),
        .ARPROT                 (S_AXI_ARPROT_1279),
        .ARVALID                (S_AXI_ARVALID_1279),
        .ARREADY                (S_AXI_ARREADY_1279),
        .RID                    (S_AXI_RID_1279),
        .RDATA                  (S_AXI_RDATA_1279),
        .RRESP                  (S_AXI_RRESP_1279),
        .RLAST                  (S_AXI_RLAST_1279),
        .RVALID                 (S_AXI_RVALID_1279),
        .RREADY                 (S_AXI_RREADY_1279),

        .IRQ                    (IRQ_1279),
        .START_OUT              (start_out_1279),
        .DONE_OUT               (done_out_1279)
    );

endmodule
