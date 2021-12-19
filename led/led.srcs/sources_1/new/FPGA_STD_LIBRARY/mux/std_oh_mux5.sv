//#############################################################################
//# Function: 5:1 one hot mux                                                 #
//#############################################################################

module std_oh_mux5 #(parameter DW = 1 ) // width of mux
(
	input 	    sel4,
	input 	    sel3,
	input 	    sel2,
	input 	    sel1,
	input 	    sel0,
	input [DW-1:0]  in4,
	input [DW-1:0]  in3,
	input [DW-1:0]  in2,
	input [DW-1:0]  in1,
	input [DW-1:0]  in0, 
	output [DW-1:0] out  //selected data output
);

assign out[DW-1:0] = ({(DW){sel0}} & in0[DW-1:0] /* IN 0*/| 
	{(DW){sel1}} & in1[DW-1:0] /* IN 1*/| 
	{(DW){sel2}} & in2[DW-1:0] /* IN 2*/| 
	{(DW){sel3}} & in3[DW-1:0] /* IN 3*/| 
	{(DW){sel4}} & in4[DW-1:0]/* IN 4*/);

endmodule // std_oh_mux5
