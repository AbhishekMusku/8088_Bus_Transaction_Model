module MemoryIO (
    input logic clk,          // Clock signal
    input logic reset,        // Reset signal
    input logic ALE,
	input logic IOM,
    input logic cs,           // Chip select signal
    input logic rd,
    input logic wr,
    input logic den,
    input logic [0:19] addr,  // Address bus (20-bit)
    inout  [7:0] data          // Data input/output bus (8-bit)
    // Data output bus (8-bit)
);
    reg OE, Write, LoadAddress;
    reg [0:19] Address;
   //parameter t=0;

    // Define states for FSM
    typedef enum logic [4:0] {
        IDLE =  5'b00001,
        LOAD =  5'b00010,
        READ =  5'b00100,
        WRITE = 5'b01000,
        TRI =   5'b10000
    } state_t;

    // Define registers for FSM
    state_t state, next_state;

    // Register to store data
    logic  [7:0] memory0 [20'h0:20'h7FFFF];  // 0-512KB memory space
    logic  [7:0] memory1 [20'h80000:20'hFFFFF];  // 512KB-1MB memory space
    reg    [7:0] m0;
	reg    [7:0] m1;
    logic  [7:0] dataout;
	reg t;

assign m0 = memory0[Address];
assign m1 =memory1[Address];
always_latch
begin
if (ALE)
	t <= IOM;
end
    // FSM logic
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always_comb begin
        next_state = state;
        unique case (state)
            IDLE : if (ALE && !t) next_state = LOAD;
            LOAD : begin
                if (!rd)       next_state = READ;
                else if (!wr && rd)  next_state = WRITE;
                else next_state = LOAD;
            end
            READ : begin
                next_state = TRI;
            end
            WRITE : begin
                next_state = TRI;
            end
            TRI : next_state = IDLE;
            default : next_state = IDLE;
        endcase
    end

    // output combinational logic
    always_comb begin
        {Write, OE, LoadAddress} = '0;

        unique case (state)
            IDLE : begin
            end
            LOAD : begin
                LoadAddress = '1;
            end
            READ : begin
                OE = '1;
            end
            WRITE : begin
                Write = '1;
            end
            TRI : begin
            end
        endcase
    end

    always_comb begin
        if (LoadAddress)
            Address = addr;
    end

    assign data = (OE) ? dataout : 8'hzz;

    // Memory and IO initialization using $readmem
    initial begin
        $readmemh("mo.txt", memory0);
        $readmemh("m1.txt", memory1);
       
		$display("Content of memory:");
    for (int i = 0; i < 1; i++) begin
      $display("[%0d] = %h", i, memory0[i]);
    end
    end
	

    always_comb begin
        if (!cs && OE && !t)  // Read operation
            dataout = memory0[Address];
        else if (cs && OE && !t)  begin// Read operation
            dataout = memory1[Address];
			end
        else
            dataout = 8'hZZ; // Tri-state output when not selected
    end

    // Data input logic for write operation
    always_comb begin
        if (!cs && Write && !t)  // Write operation
            memory0[Address] = data;
        else if (cs && Write && !t) // Write operation
            memory1[Address] = data;  
    end
endmodule
