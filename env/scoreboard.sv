class scoreboard extends uvm_scoreboard;
  uvm_analysis_imp #(apb_item, scoreboard) analysis_export; //this is the inbox for the scoreboard, it will receive apb_item transactions f
  `uvm_component_utils(scoreboard)

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction

  virtual function void write(apb_item t);
    `uvm_info("SCOREBOARD", $sformatf("Received transaction: Addr=0x%h", t.addr), UVM_MEDIUM)
  endfunction
endclass
