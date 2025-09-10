interface ahb_if(input bit HCLK,input bit HRESETn);
 logic 		HREADY;
 logic 		HWRITE;
 logic 	HRESP;
 logic [1:0]	HTRANS;
 logic [2:0] 	HBURST;
 logic [2:0] 	HSIZE;
 logic [31:0]	HADDR;
 logic [31:0]	HWDATA;
 logic [31:0]	HRDATA;

clocking m_drv_cb @(posedge HCLK);
	default input #2 output #0;
	input HRESP, HREADY, HRDATA;
	output HTRANS, HBURST, HSIZE, HADDR, HWDATA, HWRITE;
endclocking 

clocking m_mon_cb @(posedge HCLK);
	default input #2 output #0;
	input HREADY, HRESP, HTRANS, HBURST, HSIZE, HADDR, HWDATA, HRDATA, HWRITE;
endclocking

clocking s_drv_cb @(posedge HCLK);
	default input #2 output #0;
	input HTRANS, HBURST, HSIZE, HADDR, HWDATA, HWRITE;
	output HRESP, HREADY, HRDATA;
endclocking

clocking s_mon_cb @(posedge HCLK);
	default input #2 output #0;
	input HREADY, HRESP, HTRANS, HBURST, HSIZE, HADDR, HWDATA, HRDATA, HWRITE;
endclocking 

/*
clocking reset_drv_cb @(posedge HCLK);
	default input #2 output #0;
	input HRESP, HREADY, HRDATA;
	output HTRANS, HBURST, HSIZE, HADDR, HWDATA, HWRITE;
endclocking 
*/

modport master_drv (clocking m_drv_cb, input HRESETn);
modport master_mon (clocking m_mon_cb, input HRESETn);
modport slave_drv (clocking s_drv_cb, input HRESETn);
modport slave_mon (clocking s_mon_cb, input HRESETn);
//modport reset_drv (clocking reset_drv_cb, output HRESETn);


endinterface : ahb_if
