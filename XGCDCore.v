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

    reg     [31:0]              r_CTRL;
    reg                         r_IRQ;

    wire                        sram_ce_n;
    wire [31:0]                 sram_addr;
    wire [63:0]                 sram_wdata;
    wire                        sram_we_n;
    wire [7:0]                  sram_wbe_n;
    wire [63:0]                 sram_rdata;

    reg  [63:0]                 r_ARG_A[31:0];
    reg  [63:0]                 r_ARG_B[31:0];
    reg  [63:0]                 r_MASK;
    reg  [63:0]                 r_MemTemp;
    reg  [63:0]                 r_RDATA;

    integer                     i;

    //
    // APB
    //

    assign apb_addr_oft         = PADDR[11:2];
    assign apb_setup            = PSEL & ~PENABLE;
    assign apb_rd_en            = apb_setup & ~PWRITE;
    assign apb_wr_en            = apb_setup & PWRITE;

    always @(posedge CLK or negedge RESETn)
        if (!RESETn)
            r_CTRL  <= {32{1'b0}};
        else if (apb_wr_en && (apb_addr_oft == 10'd1))
            r_CTRL          <= PWDATA[31:0];

    always @(posedge CLK or negedge RESETn)
        if (!RESETn)
            r_IRQ       <= 1'b0;
        else begin
            if (apb_wr_en && (apb_addr_oft == 10'd1) & PWDATA[0])
                r_IRQ   <= 1'b1;
            else if (apb_wr_en && (apb_addr_oft == 10'd2) & PWDATA[0])
                r_IRQ   <= 1'b0;
        end

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

    AXItoSRAM u_axi_to_sram (
        .ACLK                         (CLK),
        .ARESETn                      (RESETn),

        .S_AXI_AWID                   (AWID),
        .S_AXI_AWADDR                 (AWADDR),
        .S_AXI_AWLEN                  (AWLEN),
        .S_AXI_AWSIZE                 (AWSIZE),
        .S_AXI_AWBURST                (AWBURST),
        .S_AXI_AWLOCK                 (AWLOCK),
        .S_AXI_AWCACHE                (AWCACHE),
        .S_AXI_AWPROT                 (AWPROT),
        .S_AXI_AWVALID                (AWVALID),
        .S_AXI_AWREADY                (AWREADY),
        .S_AXI_WDATA                  (WDATA),
        .S_AXI_WSTRB                  (WSTRB),
        .S_AXI_WLAST                  (WLAST),
        .S_AXI_WVALID                 (WVALID),
        .S_AXI_WREADY                 (WREADY),
        .S_AXI_BID                    (BID),
        .S_AXI_BRESP                  (BRESP),
        .S_AXI_BVALID                 (BVALID),
        .S_AXI_BREADY                 (BREADY),
        .S_AXI_ARID                   (ARID),
        .S_AXI_ARADDR                 (ARADDR),
        .S_AXI_ARLEN                  (ARLEN),
        .S_AXI_ARSIZE                 (ARSIZE),
        .S_AXI_ARBURST                (ARBURST),
        .S_AXI_ARLOCK                 (ARLOCK),
        .S_AXI_ARCACHE                (ARCACHE),
        .S_AXI_ARPROT                 (ARPROT),
        .S_AXI_ARVALID                (ARVALID),
        .S_AXI_ARREADY                (ARREADY),
        .S_AXI_RID                    (RID),
        .S_AXI_RDATA                  (RDATA),
        .S_AXI_RRESP                  (RRESP),
        .S_AXI_RLAST                  (RLAST),
        .S_AXI_RVALID                 (RVALID),
        .S_AXI_RREADY                 (RREADY),

        .SRAM_CEn                     (sram_ce_n),
        .SRAM_ADDR                    (sram_addr),
        .SRAM_WDATA                   (sram_wdata),
        .SRAM_WEn                     (sram_we_n),
        .SRAM_WBEn                    (sram_wbe_n),
        .SRAM_RDATA                   (sram_rdata)
    );

    // Write

    always @(posedge CLK) begin
        // ARG_A
        if (~sram_ce_n & ~sram_we_n && (sram_addr[11:8] == 4'd0)) begin
            r_MemTemp   = r_ARG_A[sram_addr[7:3]];
            r_MASK      = {64{1'b0}};
            for (i = 0; i < 8; i=i+1)
                if (~sram_wbe_n[i]) r_MASK[i*8 +: 8] = {8{1'b1}};
            r_ARG_A[sram_addr[7:3]] = (r_MemTemp & ~r_MASK) | (sram_wdata & r_MASK);
        end
        // ARG_B
        if (~sram_ce_n & ~sram_we_n && (sram_addr[11:8] == 4'd1)) begin
            r_MemTemp   = r_ARG_B[sram_addr[7:3]];
            r_MASK      = {64{1'b0}};
            for (i = 0; i < 8; i=i+1)
                if (~sram_wbe_n[i]) r_MASK[i*8 +: 8] = {8{1'b1}};
            r_ARG_B[sram_addr[7:3]] = (r_MemTemp & ~r_MASK) | (sram_wdata & r_MASK);
        end
    end

    // Read

    always @(posedge CLK or negedge RESETn)
        if (!RESETn)
            r_RDATA     <= {64{1'b0}};
        else if (~sram_ce_n & sram_we_n)
            case (sram_addr[11:8])
                4'd0    : r_RDATA <= r_ARG_A[sram_addr[7:3]];
                4'd1    : r_RDATA <= r_ARG_B[sram_addr[7:3]];
                default : r_RDATA <= {64{1'b0}};
            endcase

    assign sram_rdata = r_RDATA;


    //
    // IRQ, START_OUT, DONE_OUT
    //

    assign IRQ          = r_IRQ;
    assign START_OUT    = 1'b0;
    assign DONE_OUT     = 1'b0;

endmodule
