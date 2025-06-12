module router_fifo(clock,resetn,write_enb,soft_reset,read_enb,data_in,lfd_state,empty,data_out,full);
  input clock;
  input resetn;
  input write_enb;
  input soft_reset;
  input read_enb;
  input [7:0]data_in;
  input lfd_state;
  output empty;
  output reg [7:0]data_out;
  output full;

  reg [8:0]mem[15:0];
  reg [4:0]write_ptr;
  reg [4:0]read_ptr;
  reg temp;
  integer i;
  reg [4:0]count;
  assign full=((write_ptr[4]!=read_ptr[4]) && (write_ptr[3:0]==read_ptr[3:0]));
  assign empty=(write_ptr==read_ptr);

  always@(posedge clock)begin
    if(!resetn)
      temp<=0;
    else
      temp<=lfd_state;
  end

  always@(posedge clock)begin
    if(!resetn)begin
      for(i=0;i<16;i=i+1)begin
        mem[i]<=0;
        write_ptr=0;
      end
    end
    else if(soft_reset) begin
      for(i=0;i<16;i=i+1)begin
        mem[i]<=0;
        write_ptr=0;
      end
    end
    else if(write_enb && !full)begin
      {mem[write_ptr[3:0]][8],mem[write_ptr[3:0]][7:0]}<={temp,data_in};
      write_ptr<=write_ptr+1'b1;
    end
    else
      write_ptr<=write_ptr;
  end

  always@(posedge clock)begin
    if(!resetn)begin
      data_out<=0; 
      read_ptr<=0;
    end 
    else if(soft_reset)begin
      data_out<=8'bz;     
      read_ptr<=5'b0;
    end
        else if(read_enb && !empty)begin
      data_out<=mem[read_ptr[3:0]][7:0]; 
      read_ptr<=read_ptr+1'b1;
    end  
   else if(count ==0)begin 
      	    data_out<=8'bz;
    end
 
    else
      data_out<=8'bz;
  end

  always@(posedge clock)begin
    if(!resetn)   
	    count<=0;
    else if(soft_reset) 
       	    count<=0;
    else if(mem[read_ptr[3:0]][8]==1) 
       	    count<=mem[read_ptr[3:0]][7:2]+1'b1;
    else if(read_enb && !empty) 
       	    count<=count-1;
    else 
       	    count<=count;
  end
endmodule
