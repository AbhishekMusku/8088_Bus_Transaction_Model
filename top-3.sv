module top;

bit CLK = '0;
bit MNMX = '1;
bit TEST = '1;
bit RESET = '0;
bit READY = '1;
bit NMI = '0;
bit INTR = '0;
bit HOLD = '0;
bit CS ;

wire logic [7:0] AD;
logic [19:8] A;
logic HLDA;
logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;
logic [7:0] dataout;


logic [19:0] Address;
wire  [7:0]  Data;

assign CS =  Address[19];


Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);
MemoryIO   M(CLK,RESET, ALE, IOM, CS, RD, WR, DEN, Address, Data );
MemoryIO1   M1(CLK,RESET, ALE, IOM, RD, WR, DEN, Address, Data );
//MemoryIO #(1)  M1(CLK,RESET, ALE, 1'b1, RD, WR, DEN, Address, Data );



// 8282 Latch to latch bus address
always_latch
begin
if (ALE)
	Address <= {A, AD};
end

// 8286 transceiver
assign Data =  (DTR & ~DEN) ? AD   : 'z;
assign AD   = (~DTR & ~DEN) ? Data : 'z;




always #50 CLK = ~CLK;

initial
begin
$dumpfile("dump.vcd"); $dumpvars;

repeat (2) @(posedge CLK);
RESET = '1;
repeat (5) @(posedge CLK);
RESET = '0;

repeat(1000) @(posedge CLK);
$finish();
end

endmodule
