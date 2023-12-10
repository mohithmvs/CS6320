//
// Generated by Bluespec Compiler, version 2021.12.1 (build fd501401)
//
// On Sun Dec 10 11:46:06 IST 2023
//
//
// Ports:
// Name                         I/O  size props
// CLK                            I     1 clock
// RST_N                          I     1 reset
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkTestbench(CLK,
		   RST_N);
  input  CLK;
  input  RST_N;

  // ports of submodule mod
  wire [63 : 0] mod$get_res, mod$put_A_a_in, mod$put_B_b_in;
  wire mod$EN_get_res,
       mod$EN_put_A,
       mod$EN_put_B,
       mod$RDY_get_res,
       mod$RDY_put_A,
       mod$RDY_put_B;

  // declarations used by system tasks
  // synopsys translate_off
  reg [63 : 0] v__h143;
  // synopsys translate_on

  // submodule mod
  mkFPAdder64 mod(.CLK(CLK),
		  .RST_N(RST_N),
		  .put_A_a_in(mod$put_A_a_in),
		  .put_B_b_in(mod$put_B_b_in),
		  .EN_put_A(mod$EN_put_A),
		  .EN_put_B(mod$EN_put_B),
		  .EN_get_res(mod$EN_get_res),
		  .RDY_put_A(mod$RDY_put_A),
		  .RDY_put_B(mod$RDY_put_B),
		  .get_res(mod$get_res),
		  .RDY_get_res(mod$RDY_get_res));

  // submodule mod
  assign mod$put_A_a_in = 64'hC0598CCCCCCCCCCD ;
  assign mod$put_B_b_in = 64'h4027000000000000 ;
  assign mod$EN_put_A = mod$RDY_put_A && mod$RDY_put_B ;
  assign mod$EN_put_B = mod$RDY_put_A && mod$RDY_put_B ;
  assign mod$EN_get_res = mod$RDY_get_res ;

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (mod$RDY_get_res)
	begin
	  v__h143 = $time;
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (mod$RDY_get_res)
	$display("\ntime at which it completed - %0t", v__h143);
    if (RST_N != `BSV_RESET_VALUE)
      if (mod$RDY_get_res) $display("(-102.5 + 11.5) = %h", mod$get_res);
    if (RST_N != `BSV_RESET_VALUE) if (mod$RDY_get_res) $finish(32'd1);
  end
  // synopsys translate_on
endmodule  // mkTestbench

