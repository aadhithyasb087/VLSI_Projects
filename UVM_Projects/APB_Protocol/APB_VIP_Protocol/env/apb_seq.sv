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
// Filename   : apb_seq.sv HOST RX
// Description: APB
//             
// --------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
// Company:SION SEMICONDUCTORS PVT Limited 
// Engineer: 
// 
// Create Date: 18.06.2025 09:30:06
// Design Name:APB
// Module Name:sequence
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


class apb_seq extends uvm_sequence #(apb_xtn);
`uvm_object_utils(apb_seq)
function new(string name="apb_seq");
	super.new(name);
endfunction
endclass

class apb_seq1 extends apb_seq;
`uvm_object_utils(apb_seq1)
function new(string name="apb_seq1");
	super.new(name);
endfunction
task body();
repeat(3)
	begin
		req=apb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		req.pwrite=1;
		//req.print;
		finish_item(req);
		#15;
	
		start_item(req);
		req.pwrite=0;
		finish_item(req);

	end
endtask
endclass

class apb_seq2 extends apb_seq;
`uvm_object_utils(apb_seq2)
function new(string name="apb_seq2");
	super.new(name);
endfunction
task body();
	begin
		req=apb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		req.pwrite=1;
		//req.print;
		finish_item(req);

	end
endtask
endclass

class apb_seq3 extends apb_seq;
`uvm_object_utils(apb_seq3)
function new(string name="apb_seq3");
	super.new(name);
endfunction

task body();
	begin
		req=apb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() );
		req.pwrite=0;
		//req.print;
		finish_item(req);

	end
endtask
endclass

class apb_seq4 extends apb_seq;
`uvm_object_utils(apb_seq4)
function new(string name="apb_seq4");
	super.new(name);
endfunction
task body();
repeat(3)
	begin
		req=apb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		req.pwrite=1;		//req.print;
		finish_item(req);

	end
endtask
endclass

class apb_seq5 extends apb_seq;
`uvm_object_utils(apb_seq5)
function new(string name="apb_seq5");
	super.new(name);
endfunction
task body();
repeat(3)
	begin
		req=apb_xtn::type_id::create("req");
	
		start_item(req);
		assert(req.randomize());
		req.pwrite=0;
		//req.print;
		finish_item(req);

	end
endtask
endclass

class apb_seq6 extends apb_seq;
`uvm_object_utils(apb_seq6)
function new(string name="apb_seq6");
	super.new(name);
endfunction
task body();
repeat(3)
	begin
		req=apb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		req.preset=0;
		//req.print;
		finish_item(req);

	end
endtask
endclass

class apb_seq7 extends apb_seq;
`uvm_object_utils(apb_seq7)
int unsigned addr=32'h0000_1000;
function new(string name="apb_seq7");
	super.new(name);
endfunction
task body();
repeat(3)
	begin
		req=apb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		req.paddr=addr;
		//req.print;
		finish_item(req);

	end
endtask
endclass

class apb_seq8 extends apb_seq;
`uvm_object_utils(apb_seq8)
int unsigned addr=32'h0000_1001;
function new(string name="apb_seq8");
	super.new(name);
endfunction
task body();
repeat(3)
	begin
		req=apb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		//req.print;
		finish_item(req);
		#10;
		start_item(req);
		assert(req.randomize());
		req.paddr=addr;
		req.pwrite=0;
		//req.print;
		finish_item(req);
		

	end
endtask
endclass


