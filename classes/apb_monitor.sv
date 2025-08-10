//apb_monitor - passively observes bus activity and reconstructs apb_item transactions
//These transactions are then broadcasted via an analysis port
//

class apb_monitor extends uvm_monitor;
  virtual apb_interface vif;

  uvm_analysis_port #(apb_item) ap; //this is responsible to broadcast what we observes
                                    //ports, exports, and implementation ports must be created in the constructor per the UVM rules
  `uvm_component_utils(apb_monitor)

  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent)
    ap = new("ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif)) begin
      `uvm_fatal("VIF_NOT_FOUND", "Virtual interface not found for apb_monitor")
    end
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    apb_item mon_item;
    forever begin
      //wait for the SETUP phase
      @(posedge vif.PCLK);
      wait (vif.PSEL == 1'b1);
      
      //wait for ACCESS phase
      @(posedge vif.PCLK)
      wait (vif.PENABLE == 1'b1);
      wait (vif.PREADY == 1'b1);

      //at this point, the transfer data is valid
      mon_item = apb_item::type_id::create("mon_item");
      mon_item.addr = vif.PADDR;
      if (vif.PWRITE) begin
        mon_item.transferDirection = APB_WRITE;
        mon_item.data = vif.PWDATA;
      end
      else begin
        mon_item.transferDirection = APB_READ;
        mon_item.data = vif.PRDATA;
      end
      `uvm_info("MONITOR", $sformatf("Observed transaction: Addr=0x%h, Dir=0x%s, Data=0x%h", mon_item.addr, mon_item.transferDirection.name(), mon_item.data), UVM_MEDIUM)
      
      ap.write(mon_item);
    end
  endtask : run_phase

endclass : apb_monitor
