//sequences - generate stimulus for the DUT

class apb_base_sequence extends uvm_sequence #(apb_item);
  `uvm_object_utils(apb_base_sequence)

  function new(string name = "apb_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    //this will be overwritten by child classes
  endtask
endclass

class apb_write_read_sequence extends apb_base_sequence;
  `uvm_object_utils(apb_write_read_sequence)

  function new(string name = "apb_write_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    //Write value to the controlRegister
    `uvm_info("SEQUENCE", "Executing WRITE to Control Register", UVM_MEDIUM)
    `uvm_do_with(req, {
      req.addr              == 32'h00000004;
      req.transferDirection == APB_WRITE;
      req.data              == 32'hCAFEF00D;
    })

    //Read back from the Control Register
    `uvm_info("SEQUENCE", "Executing READ from Control Register", UVM_MEDIUM)
    `uvm_do_with(req, {
      req.addr              == 32'h00000004;
      req.transferDirection == APB_READ;
    })

    //read from the read-only ID Register
    `uvm_info("SEQUENCE", $sformatf("Read back data: 0x%h", req.data), UVM_MEDIUM)
    `uvm_do_with(req, {
      req.addr              == 32'h00000000;
      req.transferDirection == APB_READ;
    })
  endtask : body
endclass
