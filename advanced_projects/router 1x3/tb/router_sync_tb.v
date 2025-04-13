`timescale 1ns / 1ps

// Testbench for the router_sync module
module router_sync_tb;

    // Declare input registers for the DUT (Device Under Test)
    reg clk;
    reg rstn;
    reg full_0;
    reg full_1;
    reg full_2;
    reg empty_0;
    reg empty_1;
    reg empty_2;
    reg detect_add;
    reg [1:0] data_in;
    reg write_enb_reg;
    reg read_enb_0;
    reg read_enb_1;
    reg read_enb_2;

    // Declare output wires from the DUT
    wire fifo_full;
    wire [2:0] write_enb;
    wire soft_reset_0;
    wire soft_reset_1;
    wire soft_reset_2;
    wire vld_out_0;
    wire vld_out_1;
    wire vld_out_2;

    // Instantiate the router_sync module (UUT)
    router_sync uut (
        .clk(clk), 
        .rstn(rstn), 
        .full_0(full_0), 
        .full_1(full_1), 
        .full_2(full_2), 
        .empty_0(empty_0), 
        .empty_1(empty_1), 
        .empty_2(empty_2), 
        .detect_add(detect_add), 
        .data_in(data_in), 
        .write_enb_reg(write_enb_reg), 
        .read_enb_0(read_enb_0), 
        .read_enb_1(read_enb_1), 
        .read_enb_2(read_enb_2), 
        .fifo_full(fifo_full), 
        .write_enb(write_enb), 
        .soft_reset_0(soft_reset_0), 
        .soft_reset_1(soft_reset_1), 
        .soft_reset_2(soft_reset_2), 
        .vld_out_0(vld_out_0), 
        .vld_out_1(vld_out_1), 
        .vld_out_2(vld_out_2)
    );

    // Clock Generation: toggles every 5ns, so clock period = 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Initialize inputs to default values (used in the initialize task)
    task initialize; 
    begin
        rstn = 0;
        full_0 = 0;
        full_1 = 0;
        full_2 = 0;
        empty_0 = 0;
        empty_1 = 0;
        empty_2 = 0;
        detect_add = 0;
        data_in = 0;
        write_enb_reg = 0;
        read_enb_0 = 0;
        read_enb_1 = 0;
        read_enb_2 = 0;
    end
    endtask

    // Reset task: deassert rstn (reset signal) and then assert it again
    task reset; 
    begin
        @(negedge clk)
        rstn = 1'b0;  // Assert reset
        @(negedge clk)
        rstn = 1'b1;  // Deassert reset
        $display("[%0t] Reset completed.", $time);
    end
    endtask

    // Detect address task: sets detect_add to the value of addr_signal
    task detect_addess; 
    input addr_signal;
    begin
        @(negedge clk) 
        detect_add = addr_signal;  // Set detect_add signal
        $display("[%0t] Detect Address: detect_add = %b", $time, detect_add);
    end
    endtask

    // Address input task: assigns the input data to the data_in signal
    task address; 
    input [1:0] temp_addr;
    begin
        @(negedge clk)
        data_in = temp_addr;  // Assign address to data_in
        $display("[%0t] Address Input: data_in = %b", $time, data_in);
    end
    endtask

    // Empty input task: assigns values to empty_0, empty_1, and empty_2
    task empty; 
    input e0, e1, e2;
    begin
        empty_0 = e0;
        empty_1 = e1;
        empty_2 = e2;
        $display("[%0t] Empty Inputs: empty_0 = %b, empty_1 = %b, empty_2 = %b", $time, empty_0, empty_1, empty_2);
    end
    endtask

    // Full input task: assigns values to full_0, full_1, and full_2
    task full; 
    input f0, f1, f2;
    begin
        full_0 = f0;
        full_1 = f1;
        full_2 = f2;
        $display("[%0t] Full Inputs: full_0 = %b, full_1 = %b, full_2 = %b", $time, full_0, full_1, full_2);
    end
    endtask

    // Write enable task: sets write_enb_reg to 1 (enables writing)
    task write; 
    begin
        write_enb_reg = 1'b1;  // Enable write
        $display("[%0t] Write Enable: write_enb_reg = %b", $time, write_enb_reg);
    end
    endtask

    // Read enable task: sets read_enb_0, read_enb_1, and read_enb_2
    task read; 
    input r0, r1, r2;
    begin
        read_enb_0 = r0;
        read_enb_1 = r1;
        read_enb_2 = r2;
        $display("[%0t] Read Enables: read_enb_0 = %b, read_enb_1 = %b, read_enb_2 = %b", $time, read_enb_0, read_enb_1, read_enb_2);
    end
    endtask

    // Main simulation block
    initial begin
        // Initialize inputs and reset the DUT
        initialize;
        reset;
        
        // Simulate address detection and signal transitions
        detect_addess(0);
        address(2'b01);
        detect_addess(1);
        empty(1, 1, 0);
        full(0, 1, 0);
        write;
        read(0, 0, 0);

        // Wait for some time, then change read enable for one of the channels
        #310
        read(0, 0, 1);  // Enable read for the third channel

        // Finish simulation after 20 more time units
        #20
        $finish;
    end

    // Monitor and display the outputs every positive clock edge
    initial begin
        forever begin
            @(posedge clk)
            $display("[%0t] Outputs: fifo_full = %b, write_enb = %b, soft_reset_0 = %b, soft_reset_1 = %b, soft_reset_2 = %b, vld_out_0 = %b, vld_out_1 = %b, vld_out_2 = %b, count_2:%b", 
                $time, fifo_full, write_enb, soft_reset_0, soft_reset_1, soft_reset_2, vld_out_0, vld_out_1, vld_out_2, uut.count_2);
        end
    end

endmodule
