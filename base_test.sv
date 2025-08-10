//This file contains the test classes
//The test is the top level UVM component that builds, configures, and runs the test bench

//base_test handles creating the environment and passing down the virtual interface handle
class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  apb_env m_env;
  virtual apb_interface vif;

  function new(string name = "base_test", uvm_component parent = null)
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase)
    m_env = apb_env::type_id::create("m_env", this);
  endfunction

  //get the virtual interface from the config_db (set by tb_top)
  //and pass it down to the components that need it (driver and monitor)
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif)) begin
      `uvm_fatal("VIF_GET_FAIL", "Failed to get virtual interface in base test")
    end
    uvm_config_db#(virtual apb_interface)::set(this, "m_env.m_agent.m_driver", "vif", vif);
    uvm_config_db#(virtual apb_interface)::set(this, "m_env.m_agent.m_monitor", "vif", vif);
  endfunction
endclass

    
