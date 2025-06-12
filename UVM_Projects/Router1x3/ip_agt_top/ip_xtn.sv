class ip_xtn extends uvm_sequence_item;
  `uvm_object_utils_begin(ip_xtn)
    `uvm_field_int(header,UVM_ALL_ON)
    `uvm_field_array_int(data_in,UVM_ALL_ON)
    `uvm_field_int(parity,UVM_ALL_ON)
    `uvm_field_int(error,UVM_ALL_ON)
    `uvm_field_int(busy,UVM_ALL_ON)   
  `uvm_object_utils_end

  rand bit[7:0] header;
  rand bit[7:0] data_in[];
  rand bit[7:0] parity;
  
  bit error;
  bit busy; 
  constraint valid_addr{header[1:0]!=2'b11;}
  constraint payload_val{header[7:2] inside{[1:63]};}
  constraint payload_len{data_in.size==header[7:2];}
 // constraint payload_range{if(count==0) data_in[7:2] inside{[1:63]};}


  function void post_randomize();
     parity=parity^header;
     foreach(data_in[i])begin
       parity=parity^data_in[i];
     end
  endfunction
endclass


