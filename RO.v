module RO (
    input       wire            CLK,
    input       wire            RESETn,

    input       wire [31:0]     PADDR,
    input       wire            PSEL,
    input       wire            PENABLE,
    input       wire            PWRITE,
    input       wire [31:0]     PWDATA,
    output      wire [31:0]     PRDATA,
    output      wire            PREADY,
    output      wire            PSLVERR
);

    //
    // Internal Signals
    //

    wire                        apb_setup;
    wire                        apb_rd_en;
    wire                        apb_wr_en;
    wire    [9:0]               apb_addr_oft;

    reg     [31:0]              r_PRDATA_reg;
    reg     [31:0]              r_PRDATA;

    reg     [31:0]              r_CTRL_REG;


    //
    // APB
    //

    assign apb_setup            = PSEL & ~PENABLE;
    assign apb_rd_en            = apb_setup & ~PWRITE;
    assign apb_wr_en            = apb_setup & PWRITE;
    assign apb_addr_oft         = PADDR[11:2];

    //
    // Write
    //

    always @(posedge CLK or negedge RESETn)
        if (!RESETn)
            r_CTRL_REG  <= {32{1'b0}};
        else if (apb_wr_en && (apb_addr_oft == 10'h01))
            r_CTRL_REG  <= PWDATA;


    //
    // Read
    //

    always @(*)
        case (apb_addr_oft)
            10'h00  : r_PRDATA_reg  = 32'h5A5A5A5A;
            10'h01  : r_PRDATA_reg  = r_CTRL_REG;
            default : r_PRDATA_reg  = {32{1'b0}};
        endcase

    always @(posedge CLK or negedge RESETn)
        if (!RESETn)
            r_PRDATA    <= {32{1'b0}};
        else if (apb_rd_en)
            r_PRDATA    <= r_PRDATA_reg;


    //
    // Output Assignments
    //

    assign PRDATA   = r_PRDATA;
    assign PREADY   = 1'b1;
    assign PSLVERR  = 1'b0;
endmodule
