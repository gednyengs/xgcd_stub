module XGCDCore #(parameter  WIDTH = 32) (
    input       wire            CLK,
    input       wire            RESETn,

    input       wire [31:0]     PADDR,
    input       wire            PSEL,
    input       wire            PENABLE,
    input       wire            PWRITE,
    input       wire [31:0]     PWDATA,
    output      wire [31:0]     PRDATA,
    output      wire            PREADY,
    output      wire            PSLVERR,

    input       wire [3:0]      AWID,
    input       wire [31:0]     AWADDR,
    input       wire [7:0]      AWLEN,
    input       wire [2:0]      AWSIZE,
    input       wire [1:0]      AWBURST,
    input       wire            AWLOCK,
    input       wire [3:0]      AWCACHE,
    input       wire [2:0]      AWPROT,
    input       wire            AWVALID,
    output      wire            AWREADY,
    input       wire [63:0]     WDATA,
    input       wire [7:0]      WSTRB,
    input       wire            WLAST,
    input       wire            WVALID,
    output      wire            WREADY,
    output      wire [3:0]      BID,
    output      wire [1:0]      BRESP,
    output      wire            BVALID,
    input       wire            BREADY,
    input       wire [3:0]      ARID,
    input       wire [31:0]     ARADDR,
    input       wire [7:0]      ARLEN,
    input       wire [2:0]      ARSIZE,
    input       wire [1:0]      ARBURST,
    input       wire            ARLOCK,
    input       wire [3:0]      ARCACHE,
    input       wire [2:0]      ARPROT,
    input       wire            ARVALID,
    output      wire            ARREADY,
    output      wire [3:0]      RID,
    output      wire [63:0]     RDATA,
    output      wire [1:0]      RRESP,
    output      wire            RLAST,
    output      wire            RVALID,
    input       wire            RREADY,

    output      wire            IRQ,
    output      wire            START_OUT,
    output      wire            DONE_OUT
);

    //
    // Internal Signals
    //

    wire                        unused;

    wire                        apb_setup;
    wire                        apb_rd_en;
    wire                        apb_wr_en;
    wire    [9:0]               apb_addr_oft;

    reg     [31:0]              r_PRDATA_reg;
    reg     [31:0]              r_PRDATA;


    //
    // APB
    //

    assign apb_addr_oft         = PADDR[11:2];
    assign apb_setup            = PSEL & ~PENABLE;
    assign apb_rd_en            = apb_setup & ~PWRITE;
    assign apb_wr_en            = apb_setup & PWRITE;

    always @(*)
        case (PADDR[11:2])
            10'd0   : r_PRDATA_reg  = 32'h5A5A5A5A;
            default : r_PRDATA_reg  = {32{1'b0}};
        endcase

    always @(posedge CLK or negedge RESETn)
        if (!RESETn)
            r_PRDATA    <= {32{1'b0}};
        else if (apb_rd_en)
            r_PRDATA    <= r_PRDATA_reg;

    assign PREADY       = 1'b1;
    assign PSLVERR      = 1'b0;
    assign PRDATA       = r_PRDATA;

    //
    // AXI
    //

    assign unused   =   (| AWID)            |
                        (| AWADDR)          |
                        (| AWLEN)           |
                        (| AWSIZE)          |
                        (| AWBURST)         |
                        (| AWLOCK)          |
                        (| AWCACHE)         |
                        (| AWPROT)          |
                        (| AWVALID)         |
                        (| BREADY)          |
                        (| ARID)            |
                        (| ARADDR)          |
                        (| ARLEN)           |
                        (| ARSIZE)          |
                        (| ARBURST)         |
                        (| ARLOCK)          |
                        (| ARCACHE)         |
                        (| ARPROT)          |
                        (| ARVALID)         |
                        (| RREADY);

    assign AWREADY      = 1'b1;
    assign WREADY       = 1'b1;
    assign BID          = 4'h0;
    assign BRESP        = 2'b00;
    assign BVALID       = 1'b0;
    assign ARREADY      = 1'b1;
    assign RID          = 4'h0;
    assign RRESP        = 2'b00;
    assign RLAST        = 1'b1;
    assign RDATA        = {64{1'b0}};
    assign RVALID       = 1'b0;

    //
    // IRQ, START_OUT, DONE_OUT
    //

    assign IRQ          = 1'b0;
    assign START_OUT    = 1'b0;
    assign DONE_OUT     = 1'b0;

endmodule
