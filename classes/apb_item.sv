//TRANSACTION CLASS apb_item : a single APB operation (read or write)
//In UVM, try to first start of by thinking with higher level of abstraction - APB transfer : Perform a WRITE of data 0xDEADBEEF to address 0x04.
//TRANSACTION CLASS a.k.a. sequence item is a data container that holds information related to this operation.
//other UVM components - drivers, sequencers and monitors will create and pass these objects around

typedef enum apb_direction_e {APB_READ, APB_WRITE};
class apb_item extends uvm_sequence_item;
  rand logic [31:0] addr;
  rand logic [31:0] data; 
  rand apb_direction_e transferDirection;

  constraint c_addr_align {
    addr[1:0] == 2'b00;
  }

  `uvm_object_utils(apb_item)
  `uvm_object_utils_begin(apb_item)
      `uvm_field_enum(apb_direction_e, direction, UVM_ALL_ON)
      `uvm_field_int(addr, UVM_ALL_ON | UVM_HEX)
      `uvm_field_int(data, UVM_ALL_ON | UVM_HEX)
  `uvm_object_utils_end

  function new(string name = "apb_item");
    super.new(name);
  endfunction
endclass : apb_item
