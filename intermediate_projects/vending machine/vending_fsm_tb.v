module tb_vending_fsm;
    // Declare testbench signals
    reg clk, rst, i, j;
    wire x, y;

    // Instantiate the vending_fsm module (Unit Under Test)
    vending_fsm uut (
        .clk(clk),
        .rst(rst),
        .i(i),
        .j(j),
        .x(x),
        .y(y)
    );

    // Clock generation block: toggles every 5 time units for a 10ns period
    always #5 clk = ~clk;

    // Task to simulate coin insertion
    // coin[1] = j (Rs. 2), coin[0] = i (Rs. 1)
    task insert_coin(input [1:0] coin, input integer time_delay);
        begin
            {i, j} = coin;
            #time_delay; // Hold the coin input for specified duration
        end
    endtask

    // Main test sequence
    initial begin
        // Initialize all signals
        clk = 0; rst = 1; i = 0; j = 0;

        // Apply reset
        #10 rst = 0;

        // -----------------------
        // Test Case 1: 1 + 1 + 1
        // Expected: Rs. 3 inserted => Product Delivered
        // -----------------------
        $display("\nTest Case 1: Rs. 1 + Rs. 1 + Rs. 1 -> Product Delivered");
        insert_coin(2'b10, 10); // Insert Rs. 1
        #10 $display("Time: %0t | Product Delivered (X): %b | Coin Returned (Y): %b", $time, x, y);
        insert_coin(2'b10, 10); // Insert Rs. 1
        #10 $display("Time: %0t | Product Delivered (X): %b | Coin Returned (Y): %b", $time, x, y);
        insert_coin(2'b10, 10); // Insert Rs. 1
        #10 $display("Time: %0t | Product Delivered (X): %b | Coin Returned (Y): %b", $time, x, y);

        // Reset before next test
        clk = 0; rst = 1; i = 0; j = 0;
        #10 rst = 0;

        // -----------------------
        // Test Case 2: 2 + 1
        // Expected: Rs. 3 => Product Delivered
        // -----------------------
        $display("\nTest Case 2: Rs. 2 + Rs. 1 -> Product Delivered");
        insert_coin(2'b11, 10); // Insert Rs. 2
        #10 $display("Time: %0t | Product Delivered (X): %b | Coin Returned (Y): %b", $time, x, y);
        insert_coin(2'b10, 10); // Insert Rs. 1
        #10 $display("Time: %0t | Product Delivered (X): %b | Coin Returned (Y): %b", $time, x, y);

        // Reset before next test
        clk = 0; rst = 1; i = 0; j = 0;
        #10 rst = 0;

        // -----------------------
        // Test Case 3: 2 + 2
        // Expected: Rs. 4 => Product Delivered + Rs. 1 Returned
        // -----------------------
        $display("\nTest Case 3: Rs. 2 + Rs. 2 -> Product Delivered + Rs. 1 Returned");
        insert_coin(2'b11, 10); // Insert Rs. 2
        #10 $display("Time: %0t | Product Delivered (X): %b | Coin Returned (Y): %b", $time, x, y);
        insert_coin(2'b11, 10); // Insert Rs. 2 again
        #10 $display("Time: %0t | Product Delivered (X): %b | Coin Returned (Y): %b", $time, x, y);

        // Reset before next test
        clk = 0; rst = 1; i = 0; j = 0;
        #10 rst = 0;

        // -----------------------
        // Test Case 4: 1 + 2
        // Expected: Rs. 3 => Product Delivered
        // -----------------------
        $display("\nTest Case 4: Rs. 1 + Rs. 2 -> Product Delivered");
        insert_coin(2'b10, 10); // Insert Rs. 1
        #10 $display("Time: %0t | Product Delivered (X): %b | Coin Returned (Y): %b", $time, x, y);
        insert_coin(2'b11, 10); // Insert Rs. 2
        #10 $display("Time: %0t | Product Delivered (X): %b | Coin Returned (Y): %b", $time, x, y);

        // End simulation
        $finish;
    end
endmodule