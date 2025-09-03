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
// Filename   : apb_if.sv HOST RX
// Description: APB
//             
// --------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
// Company:SION SEMICONDUCTORS PVT Limited 
// Engineer: 
// 
// Create Date: 18.06.2025 09:30:06
// Design Name:APB
// Module Name:interface
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


interface apb_if(input logic pclk);

logic preset;
logic [31:0]paddr;
logic [31:0]pwdata;
logic [31:0]prdata;
logic pwrite;
logic penable;
logic psel;
logic pready;
logic pslverr;

clocking mdrv @(posedge pclk);
default input#1 output#1;

output pclk,preset;
output paddr,pwrite,pwdata,psel,penable;
input prdata,pready,pslverr;

endclocking

clocking mmon @(posedge pclk);
default input#1 output#1;

input pclk,preset, paddr,pwrite,pwdata,psel,penable;
input prdata,pready,pslverr; 
endclocking

clocking sdrv @(posedge pclk);
default input#1 output#1;

input preset,paddr,pwrite,pwdata,psel,penable;
output prdata,pready,pslverr;
endclocking


clocking smon @(posedge pclk);
default  input#1 output#1;

input prdata,paddr,pready,pwdata,psel,penable,pwdata,pwrite,pslverr;
endclocking

modport MDRV(clocking mdrv);
modport MMON(clocking mmon);
modport SDRV(clocking sdrv);
modport SMON(clocking smon);

endinterface
