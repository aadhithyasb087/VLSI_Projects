module uart_rx(
    input rx_clk, rx_start,
    input rst, rx,
    input [3:0] length,
    input parity_type, parity_en,
    input stop2,
    output reg [7:0] rx_out,
    output logic rx_done, rx_error
);
    
    logic parity = 0;   
    logic [7:0] datard = 0;
    int count = 0;
    int bit_count = 0;
    
    typedef enum bit [2:0] {
        idle = 0, 
        start_bit = 1, 
        recv_data = 2, 
        check_parity = 3, 
        check_first_stop = 4, 
        check_sec_stop = 5, 
        done = 6
    } state_type;
    
    state_type state = idle, next_state = idle;
    
    // State transition
    always@(posedge rx_clk) begin
        if(rst) state <= idle;
        else state <= next_state;
    end
    
    // Next state and output logic
    always@(*) begin
        case(state)
            idle: begin
                rx_done = 0;
                rx_error = 0;
                if(rx_start && !rx) 
                    next_state = start_bit;
                else
                    next_state = idle;
            end
            
            start_bit: begin
                if(count == 7 && rx) begin
                    next_state = idle;  // False start
                end
                else if (count == 15) begin
                    next_state = recv_data;
                end
                else begin
                    next_state = start_bit;
                end
            end
     
            recv_data: begin
                if(bit_count == length-1 && count == 15) begin
                    if(parity_en)
                        next_state = check_parity;
                    else
                        next_state = check_first_stop;
                end
                else begin
                    next_state = recv_data;
                end
            end
         
            check_parity: begin
                if(count == 15) begin
                    next_state = check_first_stop;
                end
                else begin
                    next_state = check_parity;
                end
            end
       
            check_first_stop: begin
                if(count == 15) begin
                    if(stop2)
                        next_state = check_sec_stop;
                    else
                        next_state = done;
                end
                else begin
                    next_state = check_first_stop;
                end
            end
            
            check_sec_stop: begin
                if(count == 15) begin
                    next_state = done;
                end
                else begin
                    next_state = check_sec_stop;
                end
            end
             
            done: begin
                rx_done = 1'b1;
                next_state = idle;
            end
            
            default: next_state = idle;
        endcase
    end
    
    // Data capture and counter logic
    always@(posedge rx_clk) begin
        case(state)
            idle: begin
                count <= 0;
                bit_count <= 0;
                datard <= 0;
            end
             
            start_bit: begin
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end
     
            recv_data: begin
                if(count == 7) begin  // Sample at midpoint
                    datard <= {rx, datard[7:1]};  // Correct shift direction
                end
                
                if(count < 15)
                    count <= count + 1;
                else begin
                    count <= 0;
                    bit_count <= bit_count + 1;
                end
            end
         
            check_parity: begin
                if(count == 7) begin
                    parity <= (parity_type) ? ^datard : ~^datard;
                    if(rx != parity)
                        rx_error <= 1'b1;
                end
                
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end
       
            check_first_stop: begin
                if(count == 7 && rx != 1'b1)
                    rx_error <= 1'b1;
                    
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end
            
            check_sec_stop: begin
                if(count == 7 && rx != 1'b1)
                    rx_error <= 1'b1;
                    
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end
             
            done: begin
                rx_out <= datard;
                count <= 0;
                bit_count <= 0;
            end
        endcase
    end
endmodule
