module ClockAndReset (
    input       wire            EXT_CLK,
    input       wire            SYS_CLK,
    input       wire [1:0]      CLK_SEL,
    input       wire            PORESETn,

    output      wire            CLK,
    output      wire            RESETn,
);

    wire        CLK;
    reg  [1:0]  r_RESETn;


    always @(posedge CLK or negedge PORESETn)
        if (!PORESETn)
            r_RESETn    <= 2'b00;
        else
            r_RESETn    <= {r_RESETn[0], 1'b1};

    assign CLK      = (CLK_SEL == 2'b00) ? SYS_CLK : EXT_CLK;
    assign RESETn   = r_RESETn[1];

endmodule
