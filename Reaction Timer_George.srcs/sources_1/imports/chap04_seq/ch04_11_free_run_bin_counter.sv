// Listing 4.11
module free_run_bin_counter
   #(parameter N=8)
   (
    input  logic clk, reset, clear_counter,
    output logic max_tick,
    output logic [N-1:0] q
   );

   //signal declaration
   logic [N-1:0] r_reg;
   logic [N-1:0] r_next;

   // body
   // register
   always_ff @(posedge clk, posedge reset)
      if (reset)
         r_reg <= 0; 
      else
         r_reg <= r_next;

   // next-state logic
  always_comb
    begin
        if (clear_counter)
            begin
                r_next = 0; 
                max_tick = 0;
                q = 0;
            end 
        else
            begin 
                r_next = r_reg + 1;
                // output logic
                q = r_reg;
                max_tick = (r_reg==2**N-1) ? 1'b1 : 1'b0;
            end
    end
endmodule