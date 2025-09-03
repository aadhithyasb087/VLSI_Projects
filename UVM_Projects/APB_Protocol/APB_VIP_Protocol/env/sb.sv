// --------------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------------
// Copyright 2017 (C) SION Semiconductors (P) Ltd. (SION)
//
// This is unpublished, confidential information. All rights reserved.
// This software contains confidential information and trade secrets.
// --------------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> WARRANTY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------------
// SION MAKES NO WARRANTY OF ANY KIND WITH REGARD TO THE USE OF THIS
// SOFTWARE, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
// --------------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> DESCRIPTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------------
//
// Filename   : sb.sv HOST RX
// Description: APB
//             
// --------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
// Company:SION SEMICONDUCTORS PVT Limited 
// Engineer: 
// 
// Create Date: 18.06.2025 09:30:06
// Design Name:APB
// Module Name:scoreboard
// Project Name:APB 
// Target Devices: 
// Tool Versions:
// Description: 
// 
// Dependencies: 
// rx_fmt
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


class sb extends uvm_scoreboard;
`uvm_component_utils(sb)

uvm_tlm_analysis_fifo #(apb_xtn) fifo_h;
uvm_tlm_analysis_fifo #(apb_xtn) fifo_h1;
virtual apb_if vif;
apb_xtn mxtn;
apb_xtn sxtn;
apb_xtn xtn;

apb_xtn cov_data;

covergroup c1;
option.per_instance=1;
	ADDR: coverpoint cov_data.paddr {bins a={[32'h8000_0000:32'h0000_03ff]};
					 bins	a1={[32'h8400_0000:32'h8400_03ff]};
					 bins	a2={[32'h8800_0000:32'h8800_03ff]};
					 bins	a3={[32'h8c00_0000:32'h8c00_03ff]};}
	
	PWDATA: coverpoint cov_data.pwdata {bins low={[0:32'h0000_ffff]};
					    bins high={[32'h0001_ffff:32'hffff_ffff]};}
	PRDATA: coverpoint cov_data.prdata {bins c={[0:32'hffff_ffff]};} 

	WRITE: coverpoint cov_data.pwrite;

 	AXB: cross ADDR,WRITE;
endgroup

function new(string name="sb",uvm_component parent);
	super.new(name,parent);
	fifo_h=new("fifo_h",this);
	fifo_h1=new("fifo_h1",this);
	c1=new();
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	cov_data=apb_xtn::type_id::create("cov_data");
		
           	if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
	`uvm_fatal("cant get","have you set it")

endfunction

task run_phase(uvm_phase phase);
fork
	begin
	forever
		begin
		fifo_h.get(mxtn);
		`uvm_info(get_type_name,$sformatf("sb from master_mon \n %s",mxtn.sprint()),UVM_LOW)
		cov_data=mxtn;
		c1.sample();
		end
	end
	begin
	forever
		begin
		fifo_h1.get(sxtn);
		`uvm_info(get_type_name,$sformatf("sb from slave_mon \n %s",sxtn.sprint()),UVM_LOW)
		cov_data=sxtn;
		c1.sample();
		end	
	end
join

endtask	

task compare_data();

begin
	if(mxtn.paddr==sxtn.paddr)
		$display("Address compared successfullSUCCESSFULLY");
	else
		$display("address not matched");
end
begin
	if(mxtn.prdata==sxtn.pwdata)
			$display("wdata compared successfullSUCCESSFULLY");
	else
			$display("rdata compared successfullSUCCESSFULLY");
	
end		
endtask	
endclass
