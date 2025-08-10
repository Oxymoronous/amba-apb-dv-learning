class apb_env extends uvm_env;
  apb_agent m_agent;
  scoreboard m_scoreboard;

  `uvm_component_utils(apb_env)
  function new(string name = "apb_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_agent = apb_agent::type_id::create("m_agent", this);
    m_scoreboard = scoreboard::type_id::create("m_scoreboard", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_agent.ap.connect(m_scoreboard.analysis_export);
  endfunction
endclass
