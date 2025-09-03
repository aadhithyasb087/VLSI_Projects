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
// Filename   : test.sv HOST RX
// Description: APB
//             
// --------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
// Company:SION SEMICONDUCTORS PVT Limited 
// Engineer: 
// 
// Create Date: 18.06.2025 04:30:06
// Design Name:APB
// Module Name:test
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


class test extends uvm_test;
`uvm_component_utils(test)
env envh;
function new(string name="test",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	envh=env::type_id::create("envh",this);
endfunction
endclass

//----------test1------
class test1 extends test;
`uvm_component_utils(test1)
apb_seq1 a_seq;
function new(string name="test1",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	a_seq=apb_seq1::type_id::create("apb_seq");
	a_seq.start(envh.m_agt.m_seqr);

	phase.drop_objection(this);
endtask
endclass

//----------test2------

class test2 extends test;
`uvm_component_utils(test2)
apb_seq2 a_seq2;

function new(string name="test2",uvm_component parent=null);
	super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
a_seq2=apb_seq2::type_id::create("a_seq2");

	phase.raise_objection(this);
	a_seq2.start(envh.m_agt.m_seqr);
	phase.drop_objection(this);
endtask
endclass

//----------test3------

class test3 extends test;
`uvm_component_utils(test3)

apb_seq3 a_seq3;
function new(string name="test3",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	a_seq3=apb_seq3::type_id::create("a_seq3");

	phase.raise_objection(this);
	a_seq3.start(envh.m_agt.m_seqr);
	phase.drop_objection(this);

endtask
endclass

//----------test4------

class test4 extends test;
`uvm_component_utils(test4)

apb_seq4 a_seq4;
function new(string name="test4",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	a_seq4=apb_seq4::type_id::create("a_seq4");

	phase.raise_objection(this);
	a_seq4.start(envh.m_agt.m_seqr);
	phase.drop_objection(this);

endtask
endclass


//----------test5------

class test5 extends test;
`uvm_component_utils(test5)

apb_seq5 a_seq5;
function new(string name="test5",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	a_seq5=apb_seq5::type_id::create("a_seq5");

	phase.raise_objection(this);
	a_seq5.start(envh.m_agt.m_seqr);
	phase.drop_objection(this);

endtask
endclass


//----------test6------

class test6 extends test;
`uvm_component_utils(test6)

apb_seq6 a_seq6;
function new(string name="test6",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	a_seq6=apb_seq6::type_id::create("a_seq6");

	phase.raise_objection(this);
	a_seq6.start(envh.m_agt.m_seqr);
	phase.drop_objection(this);

endtask
endclass

//----------test7------

class test7 extends test;
`uvm_component_utils(test7)

apb_seq7 a_seq7;
function new(string name="test7",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	a_seq7=apb_seq7::type_id::create("a_seq7");

	phase.raise_objection(this);
	a_seq7.start(envh.m_agt.m_seqr);
	phase.drop_objection(this);

endtask
endclass

class test8 extends test;
`uvm_component_utils(test8)

apb_seq8 a_seq8;
function new(string name="test8",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	a_seq8=apb_seq8::type_id::create("a_seq8");

	phase.raise_objection(this);
	a_seq8.start(envh.m_agt.m_seqr);
	phase.drop_objection(this);

endtask
endclass













