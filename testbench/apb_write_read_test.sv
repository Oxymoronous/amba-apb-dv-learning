`include "base_test.sv"

class apb_write_read_test extends base_test;
  `uvm_component_utils(apb_write_read_test)

  function new(string name = "apb_write_read_test", uvm_component parent = null);
    super.new(name, parent)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "m_env.m_agent", "is_active", UVM_ACTIVE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    apb_write_read_sequence seq;

    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting apb_write_read_sequence", UVM_MEDIUM)
    seq = apb_write_read_sequence::type_id::create("seq");
    seq.start(m_env.m_agent.m_sequencer);
    `uvm_info(get_type_name(), "Sequence finished", UVM_MEDIUM)

    #10ns;
    phase.drop_objection(this);
  endtask : run_phase
endclass
