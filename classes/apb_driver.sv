//Apb driver class : gets transaction/sequence items from the sequencer and drives them on the APB interface
//analogy = this is the mailtruck that physically delivers the letters to the bus
class apb_driver extends uvm_driver #(apb_item);
  virtual apb_interface vif;

  `uvm_component_utils(apb_driver)

  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif)) begin
      `uvm_fatal("VIF_NOT_FOUND", "Virtual interface not found for apb_driver")
    end
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    reset_signals();

    forever begin
      seq_item_port.get_next_item(req); //dont have to initialize req because get_next_item() will give a valid, pre-created object handle
      `uvm_info("DRIVER", $sformatf("Driving transaction: Addr=0x%h, Dir=%s, Data=0x%h", req.addr, req.transferDirection.name(), req.data), UVM_MEDIUM)
      drive_transfer(req);
      seq_item_port.item_done();
    end
  endtask : run_phase

  //---------------
  //Private Helper Tasks
  //---------------
  protected virtual task drive_transfer(apb_item item);
    //setup phase
    @(posedge vif.PCLK);
    vif.PSEL <= 1'b1;
    vif.PWRITE <= item.transferDirection == APB_WRITE) ? 1'b1 : 1'b0;
    vif.PADDR <= item.addr;
    if (item.transferDirection == APB_WRITE) begin
      vif.PWDATA <= item.data;
    end

    //access PHASE
    @(posedge vif.PCLK);
    vif.PENABLE <= 1'b1;
    wait (vif.PREADY == 1'b1);

    if (item.transferDirection == APB_READ) begin
      item.data = vif.PRDATA;
    end

    //End the transfer by deasserting signals 
    //current driver implementation assumes a simpler version of the state transitions - do not handle back to back transfers
    //state transitions are always IDLE > SETUP > ACCESS and repeat
    reset_signals();
  endtask : drive_transfer

  protected virtual task reset_signals();
    vif.PSEL <= 1'b0;
    vif.PENABLE <= 1'b0;
    vif.PWRITE <= 1'b0;

    vif.PADDR <= 32'b0;
    vif.PWDATA <= 32'b0;
  endtask : reset_signals
    
    
    
