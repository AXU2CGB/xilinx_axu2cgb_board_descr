//#############################################################################
//# Function: Binary to gray encoder                                          #
//#############################################################################

module std_bin2gray #(parameter DW = 32 /* width of data inputs*/) 
(
	input [DW-1:0]  bin, //binary encoded input
	output [DW-1:0] gray //gray encoded output
);

assign gray = (bin >> 1) ^ bin;

endmodule // std_bin2gray
