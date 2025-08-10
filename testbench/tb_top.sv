//Top level module for the entire simulation
//This is NOT a UVM_COMPONENT, it is the WORLDVIEW in which the UVM runs.

//import UVM package to get access to UVM types and functions
import uvm_pkg::*;

//pending to include MACROS for filepaths
`include "apb_item.sv"
`include "apb_interface.sv"
`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "scoreboard.sv"
`include "apb_agent.sv"
`include "apb_env.sv"
`include "apb_write_read_test.sv"
`include "apb_slave_dut.sv"

module tb_top;
  logic pclk;
  logic presetn;

  initial begin
    pclk = 0;
    forever #10ns pclk = ~pclk;
  end

  initial begin
    presetn = 1'b0;
    #100ns;
    presetn = 1'b1;
  end

  apb_interface apb_if (
    .PCLK(pclk),
    .PRESETN(presetn)
  );

  apb_slave_dut dut (
    .ifc(apb_if)
  );

  initial begin
    //place the virtual interface into the UVM configuration database
    //the test "base_test" will get this handle
    //this is the bridge between the static hardware world and the UVM class world
    uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top", "vif", apb_if);

    run_test("apb_write_read_test");
  end
endmodule
