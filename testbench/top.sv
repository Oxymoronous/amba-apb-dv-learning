// Code your testbench here
// or browse Examples
import uvm_pkg::*;
`include "apb_item.sv"

module top;
  initial begin
    apb_item my_item;
    my_item = new("my_item");

    repeat (5) begin
      if(!my_item.randomize()) begin
        `uvm_fatal("RND_FAIL", "Failed to randomize apb_item")
      end

      my_item.print();
      $display"------------------------------------------");
    end
  end
endmodule
