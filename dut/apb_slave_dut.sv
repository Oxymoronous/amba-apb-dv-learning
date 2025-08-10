//Simple SV module to act as APB Slave
//simple slave just to test basic read and writes, with some basic registers
//Specs for register memory map:
//0x00 : ID Register (RO, 32bit) returns a fixed value
//0x04 : Control Register (RW, 32bit) general purpose register
//0x08 : Status Register (RO, 32bit) bit[0] of this register will mirror bit[0] of the control register
//0x0C : Data Register (RW, 32bit) another general purpose register

//Behavior : 
//Slave will respond immediately = will not use wait states (PREADY will always be high during the access phase)
//will not generate error for now - PSLVERR will always be low

module apb_slave_dut (
  apb_interface.slave ifc  //this is the powerful concept of interface - we can directly pass in the modport of the interface and let it handle the signal directions, instead of having an extremely long list
);

  localparam ADDR_ID   =  32'h00;
  localparam ADDR_CTRL =  32'h04;
  localparam ADDR_STATUS  =  32'h08;
  localparam ADDR_DATA    =  32'h0C;

  //registers
  logic [31:0] reg_id;
  logic [31:0] reg_ctrl;
  logic [31:0] reg_status;
  logic [31:0] reg_data;

  initial begin
    reg_id = 32'hDEADBEEF;
    reg_ctrl = 32'h0;
    reg_data = 32'h0;
  end

  assign reg_status[0] = reg_ctrl[0];

  always_ff @(posedge ifc.PCLK or negedge ifc.PRESETn) begin
    if (!ifc.PRESETn) begin
      reg_ctrl <= 32'b0;
      reg_data <= 32'b0;
    end
    else begin
      if (ifc.PSEL && ifc.PENABLE && ifc.PWRITE) begin
        case (ifc.PADDR)
          ADDR_CTRL: reg_ctrl <= ifc.PWDATA;
          ADDR_DATA: reg_data <= ifc.PWDATA;
          default: begin 
            //do nothing as other register are RO
          end
        endcase
      end
    end

    always_comb begin
      ifc.PRDATA = 32'b0;

      if (ifc.PSEL && ifc.PENABLE && !ifc.PWRITE) begin
        case (ifc.PADDR)
          ADDR_ID      :  ifc.PRDATA = reg_id;
          ADDR_CTRL    :  ifc.PRDATA = reg_ctrl;
          ADDR_STATUS  :  ifc.PRDATA = reg_status;
          ADDR_DATA    :  ifc.PRDATA = reg_data;
          default      :  ifc.PRDATA = 32'h0;
        endcase
      end
    end

    //based on header simple DUT design, slave is always ready and never has error
    assign ifc.PREADY = 1'b1;
    assign ifc.PSLVERR = 1'b0;
endmodule
    
      
