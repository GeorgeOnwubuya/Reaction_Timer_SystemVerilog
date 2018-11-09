// LFSR Fibonacci 168 bit pseudorandom number generator
//     maximal poly for 168 is 168,166,153,151
//     don't forget to subtract 1 since we are 0-167
//     key1-4 are binary digits of pi used to add initial information
//     Note this is pseudorandom, and linear.  It won't repeat for a long time
//     but it is predictable after a much shorter time so it should not be used
//     for apps needing true randomness, such as cryptography, gambling, etc.

module LFSR_fib168(
  input logic clk,
  input logic reset,
  input logic [27:0] seed,
  output logic [3:0] r
);
  logic [167:0] state, next_state;
  logic polynomial;

  assign polynomial = state[167]^state[165]^state[152]^state[151];
  assign next_state = {state[166:0],polynomial};

  always_ff @(posedge(clk), posedge(reset))
    if(reset)
      state <= {seed,~seed,seed,seed,~seed,~seed};
    else
      state <= next_state;

  assign r = state[3:0];
  
  // Random numbers from 2 - 15
  //always_comb
    //begin
        //r = state [3:0]; 
        //if (r == 4'b0)
            //begin
                //r = next_state[3:0];
             //end
        //else if (r == 4'b1)
            //begin
                //r = next_state[3:0];
            //end
        //else
            //begin 
                //r = state[3:0];;
            //end
           
    //end
             
  endmodule
