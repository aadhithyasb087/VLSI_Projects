
`define WIDTH 32
 `define BYTE 8
 `define HALFWORD 16
 `define WORD 32
 
typedef enum bit [1:0] {IDLE, BUSY, NONSEQ, SEQ} transfer_t;
typedef enum bit [2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} burst_t;
typedef enum bit [2:0] {BYTE, HALFWORD, WORD} size_t;

