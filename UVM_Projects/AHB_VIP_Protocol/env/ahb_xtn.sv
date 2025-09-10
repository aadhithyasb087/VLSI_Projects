class ahb_xtn extends uvm_sequence_item;

  bit	 	    HRESETn;
  rand bit [31:0]   HADDR [];
  rand burst_t	    HBURST;
  rand size_t 	    HSIZE;
  rand transfer_t   HTRANS;
  rand bit [31:0]   HWDATA [];
  rand bit HWRITE;
  bit [31:0]	    HRDATA;
  bit 		    HREADY;
  bit	    HRESP;
  

`uvm_object_utils_begin(ahb_xtn)
	`uvm_field_int(HRESETn, UVM_ALL_ON)
	`uvm_field_array_int(HADDR, UVM_ALL_ON)
	`uvm_field_enum(burst_t,HBURST, UVM_ALL_ON)
	`uvm_field_enum(size_t,HSIZE, UVM_ALL_ON)
	`uvm_field_enum(transfer_t,HTRANS, UVM_ALL_ON)
	`uvm_field_array_int(HWDATA, UVM_ALL_ON)
	`uvm_field_int(HWRITE, UVM_ALL_ON)
	`uvm_field_int(HRDATA, UVM_ALL_ON)
	`uvm_field_int(HREADY, UVM_ALL_ON)
	`uvm_field_int(HRESP, UVM_ALL_ON)
`uvm_object_utils_end

 constraint addr_size{
		 HADDR.size > 0;
		 if(HBURST == SINGLE) HADDR.size == 1;
		 if(HBURST == INCR) HADDR.size < (1024 / (2 ** HSIZE));
		 if(HBURST == INCR4 || HBURST == WRAP4) HADDR.size == 4;
		 if(HBURST == INCR8 || HBURST == WRAP8) HADDR.size == 8;
		 if(HBURST == INCR16 || HBURST == WRAP16) HADDR.size == 16;
 }
 
 constraint wdata{
		HWDATA.size == HADDR.size;
 }
 
 /*constraint htrans{
		HTRANS.size == HADDR.size;
 }*/
 
 constraint hsize{
		HSIZE inside {[0:2]};
 }

  /*constraint first_trans_type{ // single transfers can be IDLE or NONSEQ
		if(HBURST == SINGLE){
			 HTRANS[0] inside { IDLE, NONSEQ };
		}
		else{
			foreach(HTRANS[i])
				if(i == 0)
					HTRANS[i] == NONSEQ;
				else 
					HTRANS[i] == SEQ;
			}
 }
 */

 constraint addr_boundary{ //all transfers in a burst must be aligned to the address boundary equal to the size of transfers
	if(HSIZE == HALFWORD)
		foreach(HADDR[i])
			soft HADDR[i][0] == 0;

	if(HSIZE == WORD)
		foreach(HADDR[i])
			soft HADDR[i][1:0] == 0;
 }

 
 constraint addr_vals{
	if(HBURST == INCR || HBURST == INCR4 || HBURST == INCR8 || HBURST == INCR16)
		foreach(HADDR[i])
			if(i > 0) 
				HADDR[i] == HADDR[i-1] + 2**HSIZE;
 }

 constraint addr_4beat_wrap{
	if(HBURST == WRAP4){
		if(HSIZE == BYTE)
			foreach(HADDR[i])
				if(i > 0){
					HADDR[i][1:0] == HADDR[i-1][1:0] + 1;
					HADDR[i][31:2] == HADDR[i-1][31:2];
				}

		if(HSIZE == HALFWORD)
		     
			foreach(HADDR[i])
				if(i > 0){
					HADDR[i][2:1] == HADDR[i-1][2:1] + 1;
					HADDR[i][31:3] == HADDR[i-1][31:3];
				}

		if(HSIZE == WORD)
			foreach(HADDR[i])
				if(i > 0){
					HADDR[i][3:2] == HADDR[i-1][3:2] + 1;
					HADDR[i][31:4] == HADDR[i-1][31:4];
				}
	}
 }

 constraint addr_8beat_wrap{
	if(HBURST ==  WRAP8){
		if(HSIZE == BYTE)
			foreach(HADDR[i])
				if(i > 0){
					HADDR[i][2:0] == HADDR[i-1][2:0] + 1;
					HADDR[i][31:3] == HADDR[i-1][31:3];
				}

		if(HSIZE == HALFWORD)
			foreach(HADDR[i])
				if(i > 0){
					HADDR[i][3:1] == HADDR[i-1][3:1] + 1;
					HADDR[i][31:4] == HADDR[i-1][31:4];
				}
	
		if(HSIZE == WORD)
			foreach(HADDR[i])
				if(i > 0){
					HADDR[i][4:2] == HADDR[i-1][4:2] + 1;
					HADDR[i][31:5] == HADDR[i][31:5];
				}
	}
	
 }	

 constraint addr_16beat_wrap{
	if(HBURST == WRAP16){
		if(HSIZE == BYTE)
			foreach(HADDR[i])
				if(i > 0){
					HADDR[i][3:0] == HADDR[i-1][3:0] + 1;
					HADDR[i][31:4] == HADDR[i-1][31:4];
				}
	
		if(HSIZE == HALFWORD)
			foreach(HADDR[i])
				if(i > 0){
					HADDR[i][4:1] == HADDR[i-1][4:1] + 1;
					HADDR[i][31:5] == HADDR[i-1][31:5];
				}
		
		if(HSIZE == WORD)
			foreach(HADDR[i])
				if(i > 0){
					HADDR[i][5:2] == HADDR[i-1][5:2] + 1;
					HADDR[i][31:6] == HADDR[i-1][31:6];
				}
	}

 }
 
/* constraint ready_cycle{ 
          ready.size == haddr.size;
          foreach(ready[i])
              ready[i] dist { 0 := 2, 1 := 5};
  }
  */
 
function new(string name="ahb_master_xtn");
	super.new(name);
endfunction : new

 
endclass : ahb_xtn
