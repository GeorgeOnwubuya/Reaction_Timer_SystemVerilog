`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2018 10:38:03 AM
// Design Name: 
// Module Name: Display_Mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Display_Mux(
    input logic CLK100MHZ, Clear_btn, Start_btn, Stop_btn, BTNL,
    output logic [7:0] AN,
    output logic [7:0] sseg,
    output logic LED0
    //output logic [3:0] digit1,digit2, digit3
    );
           
//State type
typedef enum logic [4:0]{Init, Check_RandomNumber, Number_Counter, Start, Stop} state_type;
      
//signal declaration
logic [3:0] a, b;
logic [7:0] sum;
logic [3:0] random_number; 
logic [31:0] check_number;
state_type current_state, next_state;
       

//Use only two parts of the 7-segment       
assign AN[7:4] = 4'b1111;

//Initialization 
always_ff@(posedge CLK100MHZ)
    current_state <= next_state;
    
always_comb
    begin
    next_state = current_state;
    case(current_state)
    Init:
        begin
        //Display "Hi" on 7-segment
        a = 4'ha; 
        b = 4'hb;
        sum[7:4]= 4'hc;
        sum[3:0]= 4'hc;
        
        LED0 = 1'b0;
        
        if (Start_btn ==1)
            begin
                next_state = Check_RandomNumber;          
            end
        end
     
     Check_RandomNumber:
        begin
            a = 4'hc;
            b = 4'hc;
            sum[7:4] = 4'hc;
            sum[3:0] = 4'hc;
            
            LED0 = 1'b0;
            
            if(random_number > 4'b0001)
                begin
                    next_state = Start; 
                end            
        end
        
     Start: 
        begin
            a = 4'hc;
            b = 4'hc;
            sum[7:4] = 4'hc;
            sum[3:0] = 4'hc;
            
            LED0 = 1'b0;
            
            if (random_number*1000000000 == check_number)
                begin
                    next_state = Number_Counter;
                end
        end
        
    Number_Counter:
        begin
            a = 4'hc;
            b = 4'hc;
            sum[7:4] = 4'hc;
            sum[3:0] = 4'hc;
            
            LED0 = 1'b1;
            //Start stopwatch
            
            if (Stop_btn ==1)
                begin
                    next_state = Stop;
                end
            
        end       
    Stop:
        begin
            a = 4'hc;
            b = 4'hc;
            sum[7:4] = 4'hc;
            sum[3:0] = 4'hc;
            
            LED0 = 1'b0;
            
            //if(Stop_btn == 1)
                //begin
                    //LED0 = 1'b0;
                //end
         end
         
     default:
        begin
            a = 4'hc;
            b = 4'hc;
            sum[7:4] = 4'hc;
            sum[3:0] = 4'hc;
            
            LED0 = 1'b0;
        end
      
    endcase
    end
//always_comb
    //begin
    
        //else
            //begin
                //a = 4'hc;
                //b = 4'hc;
                //sum[7:4] = 4'hc;
                //sum[3:0] = 4'hc;
            //end
       //end
      
// Instantiate 7-seg LED display module
    disp_hex_mux disp_unit
        (.clk(CLK100MHZ), .reset(1'b0),
        .hex3(sum[7:4]), .hex2(sum[3:0]), .hex1(b), .hex0(a),
        .dp_in(4'b1111), .an(AN[3:0]), .sseg(sseg));
          
// Instantiate Random-Number Generator
    LFSR_fib168 Random_Number_Gen 
        (.clk(CLK100MHZ), .reset(BTNL), .seed(28'b0101010001110101000101100010), .r(random_number));
    
//Instantiate Binary Counter
    free_run_bin_counter #(.N(32)) Counter
        (.clk(CLK100MHZ), .reset(1'b1), .clear_counter(1'b0), .max_tick(), .q(check_number));  
        
//Instantiate Stop Watch
    //stop_watch_if StopWatch
        //(.clk(CLK100MHZ), 

       // adder
      // assign a = SW[3:0];
       //assign b = SW[7:4];
       //assign sum = {4'b0,a} + {4'b0,b}; 
    
endmodule
