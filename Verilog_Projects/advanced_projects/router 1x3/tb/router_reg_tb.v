`timescale 1ns / 1ps

// Testbench module for router_reg
module router_reg_tb();

    // Declare all input registers for the DUT (Device Under Test)
    reg clk, rstn, pkt_valid, fifo_full, detect_add, ld_state, laf_state, full_state, lfd_state, rst_int_reg;
    reg [7:0] data_in;  // 8-bit data input for the DUT
    // Declare output wires from the DUT
    wire err, parity_done, low_pkt_valid;
    wire [7:0] data_out;
    integer i;  // Variable for iteration in the packet tasks

    // Instantiate the router_reg module
    router_reg DUT(
        .clk(clk),
        .rstn(rstn),
        .pkt_valid(pkt_valid),
        .fifo_full(fifo_full),
        .detect_add(detect_add),
        .ld_state(ld_state),
        .laf_state(laf_state),
        .full_state(full_state),
        .lfd_state(lfd_state),
        .rst_int_reg(rst_int_reg),
        .data_in(data_in),
        .err(err),
        .parity_done(parity_done),
        .low_pkt_valid(low_pkt_valid),
        .data_out(data_out)
    );

    // Clock generation: toggles every 5ns, so clock period = 10ns
    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    // Reset task: it deasserts and then asserts the reset signal to reset the DUT
    task reset;
        begin
            rstn = 1'b0;  // Reset asserted
            #10;  // Wait for 10ns
            rstn = 1'b1;  // Reset deasserted
        end
    endtask

    // Task for simulating Packet 1
    task packet1();
        reg [7:0] header, payload_data, parity;
        reg [5:0] payloadlen;
        begin
            // Start of packet 1 simulation
            @(negedge clk);  // Wait for the negative edge of the clock
            payloadlen = 8;  // Length of the payload
            parity = 0;  // Initialize parity

            // Set up header with payload length and address
            detect_add = 1'b1;
            pkt_valid = 1'b1;
            header = {payloadlen, 2'b10};  // Creating header
            data_in = header;
            parity = parity ^ data_in;  // Update parity with header

            @(negedge clk);  // Wait for the next clock edge
            detect_add = 1'b0;
            lfd_state = 1'b1;  // Set lfd_state to 1

            // Send the payload data
            for(i = 0; i < payloadlen; i = i + 1) begin
                @(negedge clk);  // Wait for each clock edge
                lfd_state = 0;
                ld_state = 1;  // Load data state is active

                payload_data = {$random} % 256;  // Generate random 8-bit data
                data_in = payload_data;  // Assign data to input
                parity = parity ^ data_in;  // Update parity with new data
            end

            // End of packet transmission
            @(negedge clk);
            pkt_valid = 0;  // Deassert pkt_valid
            data_in = parity;  // Send parity value as last byte

            @(negedge clk);  // Wait for the clock edge
            ld_state = 0;  // Deassert load state
        end
    endtask

    // Task for simulating Packet 2 (similar to Packet 1)
    task packet2();
        reg [7:0] header, payload_data, parity;
        reg [5:0] payloadlen;
        begin
            // Start of packet 2 simulation
            @(negedge clk);  // Wait for the negative edge of the clock
            payloadlen = 8;  // Length of the payload
            parity = 0;  // Initialize parity

            // Set up header with payload length and address
            detect_add = 1'b1;
            pkt_valid = 1'b1;
            header = {payloadlen, 2'b10};  // Creating header
            data_in = header;
            parity = parity ^ data_in;  // Update parity with header

            @(negedge clk);  // Wait for the next clock edge
            detect_add = 1'b0;
            lfd_state = 1'b1;  // Set lfd_state to 1

            // Send the payload data
            for(i = 0; i < payloadlen; i = i + 1) begin
                @(negedge clk);  // Wait for each clock edge
                lfd_state = 0;
                ld_state = 1;  // Load data state is active

                payload_data = {$random} % 256;  // Generate random 8-bit data
                data_in = payload_data;  // Assign data to input
                parity = parity ^ data_in;  // Update parity with new data
            end

            // End of packet transmission
            @(negedge clk);
            pkt_valid = 0;  // Deassert pkt_valid
            data_in = !parity;  // Send inverted parity value as last byte

            @(negedge clk);  // Wait for the clock edge
            ld_state = 0;  // Deassert load state
        end
    endtask

    // Testbench initialization
    initial begin
        reset;  // Apply reset
        fifo_full = 1'b0;  // FIFO is not full initially
        laf_state = 1'b0;  // Initialize laf_state to 0
        full_state = 1'b0;  // Initialize full_state to 0

        // Start sending packets
        #20;
        $display("[INFO] Sending Packet 1...");
        packet1();  // Call packet1 task
        #75;  // Wait for 75ns before sending the next packet
        $display("[INFO] Sending Packet 2...");
        packet2();  // Call packet2 task
        #10;

        // Finish simulation
        $finish;
    end

endmodule
