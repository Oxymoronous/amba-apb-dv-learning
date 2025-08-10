//uvm_agent - encapsulates the driver, the sequencer, and monitor
//uvm_agent can be configured to be ACTIVE or PASSIVE 

class apb_agent extends uvm_agent;
  apb_driver m_driver;
  apb_sequencer m_sequencer;
  apb_monitor m_monitor;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  //analysis port for the agent to broadcase transactions from the monitor
  uvm_analysis_port #(apb_item) ap;

  `uvm_component_utils(apb_agent)

  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  //UVM_PHASE
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_monitor = apb_monitor::type_id::create("m_monitor", this);

    //create the driver and sequencer ONLY if in ACTIVE mode
    if (is_active == UVM_ACTIVE) begin
      m_driver = apb_driver::type_id::create("m_driver", this);
      m_sequencer = apb_sequencer::type_id::create("m_sequencer", this);
    end
  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (is_active == UVM_ACTIVE) begin
      m_driver.seq_item_port.connect(m_sequencer, seq_item_export);
    end

    m_monitor.ap.connect(this.ap); //connect the monitor's analysis port to the agent's analysis port
  endfunction : connect_phase

endclass
