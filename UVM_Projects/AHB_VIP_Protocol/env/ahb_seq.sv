class ahb_seq extends uvm_sequence #(ahb_xtn);
  `uvm_object_utils(ahb_seq)
  ahb_xtn xtn;
  function new(string name = "ahb_seq_base");
    super.new(name);
  endfunction
endclass

//single byte
class seq0 extends ahb_seq;

`uvm_object_utils(seq0)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == SINGLE; xtn.HWRITE==1;xtn.HSIZE == 0;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//incr4 byte
class seq1 extends ahb_seq;

`uvm_object_utils(seq1)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == INCR4; xtn.HWRITE==1;xtn.HSIZE == 0;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);


endtask
endclass


//--------wrap4 byte-------------//
class seq2 extends ahb_seq;
`uvm_object_utils(seq2)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == WRAP4; xtn.HWRITE==1;xtn.HSIZE == 0;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------incr8 byte--------------//
class seq3 extends ahb_seq;
`uvm_object_utils(seq3)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == INCR8; xtn.HWRITE==1;xtn.HSIZE == 0;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------wrap8 byte--------------//
class seq4 extends ahb_seq;
`uvm_object_utils(seq4)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == WRAP8; xtn.HWRITE==1;xtn.HSIZE == 0;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------incr16 byte--------------//
class seq5 extends ahb_seq;
`uvm_object_utils(seq5)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == INCR16; xtn.HWRITE==1;xtn.HSIZE == 0;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------wrap16 byte-------------//
class seq6 extends ahb_seq;
`uvm_object_utils(seq6)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == WRAP16; xtn.HWRITE==1;xtn.HSIZE == 0;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------incr4 halfword--------------//
class seq7 extends ahb_seq;
`uvm_object_utils(seq7)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == INCR4; xtn.HWRITE==1;xtn.HSIZE == 1;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------wrap4 halfword--------------//
class seq8 extends ahb_seq;
`uvm_object_utils(seq8)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == WRAP4; xtn.HWRITE==1;xtn.HSIZE == 1;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------incr8 halfword--------------//
class seq9 extends ahb_seq;
`uvm_object_utils(seq9)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == INCR8; xtn.HWRITE==1;xtn.HSIZE == 1;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------wrap8 halfword--------------//
class seq10 extends ahb_seq;
`uvm_object_utils(seq10)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == WRAP8; xtn.HWRITE==1;xtn.HSIZE == 1;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------incr16 halfword--------------//
class seq11 extends ahb_seq;
`uvm_object_utils(seq11)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == INCR16; xtn.HWRITE==1;xtn.HSIZE == 1;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------wrap16 halfword--------------//
class seq12 extends ahb_seq;
`uvm_object_utils(seq12)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == WRAP16; xtn.HWRITE==1;xtn.HSIZE == 1;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass



//-------------incr4 word--------------//
class seq13 extends ahb_seq;
`uvm_object_utils(seq13)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == INCR4; xtn.HWRITE==1;xtn.HSIZE == 2;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------wrap4 word--------------//
class seq14 extends ahb_seq;
`uvm_object_utils(seq14)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == WRAP4; xtn.HWRITE==1;xtn.HSIZE == 2;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------incr8 word--------------//
class seq15 extends ahb_seq;
`uvm_object_utils(seq15)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == INCR8; xtn.HWRITE==1;xtn.HSIZE == 2;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------wrap8 word--------------//
class seq16 extends ahb_seq;
`uvm_object_utils(seq16)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == WRAP8; xtn.HWRITE==1;xtn.HSIZE == 2;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------incr16 word--------------//
class seq17 extends ahb_seq;
`uvm_object_utils(seq17)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == INCR16; xtn.HWRITE==1;xtn.HSIZE == 2;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass

//-------------wrap16 word--------------//
class seq18 extends ahb_seq;
`uvm_object_utils(seq18)

function new(string name="");
	super.new(name);
endfunction

task body();
xtn=ahb_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with {xtn.HBURST == WRAP16; xtn.HWRITE==1;xtn.HSIZE == 2;});
	finish_item(xtn);
    xtn.HWRITE=0;
	start_item(xtn);
	finish_item(xtn);
endtask
endclass
