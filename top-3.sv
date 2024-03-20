interface Intel8088Pins (input logic CLK, RESET);
logic MNMX = '1;
logic TEST = '1;
logic READY = '1;
logic NMI = '0;
logic INTR = '0;
logic HOLD = '0;

logic HLDA;
tri [7:0] AD;
tri [19:8] A;

logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;

modport Processor ( input CLK, 

input MNMX,
input TEST,
input RESET,
input READY,
input NMI,
input INTR,
input HOLD,

inout AD,
output A,
output HLDA,
output IOM,
output WR,
output RD,
output SSO,
output INTA,
output ALE,
output DTR,
output DEN
);

modport Peripheral ( input CLK, 

input IOM,
input WR,
input RD,
input ALE,
input DEN
);

endinterface

module top;

parameter mem0 =0;
parameter mem1 =1;
parameter IO0 =2;
parameter IO1 =3;

bit CLK ='1;
bit RESET = '0;
bit CS ;
logic [19:0] Address;
wire  [7:0]  Data;

assign CS =  Address[19];

Intel8088Pins p1(CLK, RESET);
Intel8088 p(p1.Processor);

//Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);
MemoryIO #(mem0)  M(CLK,RESET, p1.ALE, p1.IOM, CS, p1.RD, p1.WR, p1.DEN, Address, Data );
MemoryIO #(mem1)  M1(CLK,RESET, p1.ALE, p1.IOM, CS, p1.RD, p1.WR, p1.DEN, Address, Data );
MemoryIO #(IO0)  M2(CLK,RESET, p1.ALE, p1.IOM, CS, p1.RD, p1.WR, p1.DEN, Address, Data );
MemoryIO #(IO1)  M3(CLK,RESET, p1.ALE, p1.IOM, CS, p1.RD, p1.WR, p1.DEN, Address, Data );



// 8282 Latch to latch bus address
always_latch
begin
if (p1.ALE)
	Address <= {p1.A, p1.AD};
end

// 8286 transceiver
assign Data =  (p1.DTR & ~p1.DEN) ? p1.AD   : 'z;
assign p1.AD   = (~p1.DTR & ~p1.DEN) ? Data : 'z;




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
