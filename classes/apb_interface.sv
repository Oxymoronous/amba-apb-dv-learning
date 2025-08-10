//APB interface - bundles all the APB signals into a single, neat "cable"
interface apb_interface(input logic PCLK, input logic PRESETn);
  //Signal Declarations
  logic [31:0] PADDR;
  logic [31:0] PWDATA;
  logic [31:0] PRDATA;
  logic PSEL;
  logic PENABLE;
  logic PWRITE;
  logic PREADY;
  logic PSLVERR;

  //Modports
  //from the perspective of the driver
  modport master (
    output PADDR, PSEL, PENABLE, PWRITE, PWDATA,
    input PREADY, PRDATA, PSLVERR, PCLK, PRESETn
  );

  //from the perspective of the Slave (our DUT)
  modport slave (
    input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PCLK, PRESETn,
    output PREADY, PRDATA, PSLVERR
  );

  modport monitor (
    input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PREADY, PRDATA, PSLVERR, PCLK, PRESETn
  );

endinterface
  
  
