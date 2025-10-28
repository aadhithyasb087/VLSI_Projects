module branch_unit(rs1_in,  rs2_in,  opcode_6_to_2_in,  
	funct3_in,  branch_taken_out);

input [31:0]rs1_in,  rs2_in;
input [4:0]opcode_6_to_2_in;
input [2:0]funct3_in;
wire signed [31:0]w1,w2;
assign w1=rs1_in;
assign w2=rs2_in;

output reg branch_taken_out;

always@(*)
begin
	if(opcode_6_to_2_in==5'b11000)
		begin
			case(funct3_in)
				3'b000:branch_taken_out=(rs1_in==rs2_in)?1'b1:1'b0;
				3'b001:branch_taken_out=(rs1_in!=rs2_in)?1'b1:1'b0;
				3'b100:branch_taken_out=(w1<w2)?1'b1:1'b0;
				3'b101:branch_taken_out=(w1>=w2)?1'b1:1'b0;
				3'b110:branch_taken_out=(rs1_in<rs2_in)?1'b1:1'b0;
				3'b111:branch_taken_out=(rs1_in>=rs2_in)?1'b1:1'b0;
				default:branch_taken_out=1'b0;
			endcase
		end
		
	else if(opcode_6_to_2_in==5'b11011)
		branch_taken_out=1'b1;
		
	else if (opcode_6_to_2_in==5'b11001&&funct3_in==3'b000)
		branch_taken_out=1'b1;
		
	else
		branch_taken_out=1'b0;
end

endmodule
