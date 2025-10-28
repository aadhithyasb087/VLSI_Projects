module integer_file(ms_riscv32_mp_clk_in,ms_riscv32_mp_rst_in,rs_2_addr_in,rd_addr_in,wr_en_in,rd_in,rs_1_addr_in,rs_1_out,rs_2_out);
input ms_riscv32_mp_clk_in,ms_riscv32_mp_rst_in,wr_en_in;
input [4:0]rs_2_addr_in,rd_addr_in,rs_1_addr_in;
input [31:0]rd_in;
output reg[31:0]rs_1_out,rs_2_out;
reg [31:0]reg_file[31:0];
integer i;

always@(posedge ms_riscv32_mp_clk_in)
begin
	if(ms_riscv32_mp_rst_in)begin
		for(i=0;i<32;i=i+1)
		reg_file[i]<=32'b0;
	end
	else if(wr_en_in)
		reg_file[rd_addr_in]<=rd_in;
	else 
		reg_file[rd_addr_in]<=reg_file[rd_addr_in];
end

always@(*)
begin
	if(ms_riscv32_mp_rst_in)
	begin
		rs_1_out<=0;
		rs_2_out<=0;
	end
	else
	begin
		rs_1_out<=((rs_1_addr_in==rd_addr_in)&&wr_en_in)?rd_in:reg_file[rs_1_addr_in];
		rs_2_out<=((rs_2_addr_in==rd_addr_in)&& wr_en_in)?rd_in:reg_file[rs_2_addr_in];
	end
	end
	endmodule
	
