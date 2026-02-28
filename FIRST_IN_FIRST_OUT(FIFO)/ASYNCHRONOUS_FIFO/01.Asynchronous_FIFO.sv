// Asynchronous FIFO - Pointer with Extra MSB method
module async_fifo #(parameter WIDTH = 8,
                    parameter DEPTH = 4) (
  // write domain
  input 					wr_clk,
  input 					wr_rst,
  input 					wr_en,
  input logic [WIDTH -1 :0]	data_in,
  output 					full,

  // read domain
  input 					 rd_clk,
  input 					 rd_rst,
  input						 rd_en,
  output logic [WIDTH -1 :0] data_out,
  output 					 empty
);
  
  // local parameter
  localparam PTR_WIDTH = $clog2(DEPTH);
  
  // fifo memory
  logic [WIDTH - 1:0]fifo[DEPTH - 1:0];
  
  // write pointer and gray  --- pointer Width has 1 extra MSB bit
  logic [PTR_WIDTH:0] bin_wr_ptr, bin_wr_ptr_next;
  logic [PTR_WIDTH:0] gray_wr_ptr, gray_wr_ptr_next;
  
  // read pointer and gray
  logic [PTR_WIDTH:0] bin_rd_ptr, bin_rd_ptr_next;
  logic [PTR_WIDTH:0] gray_rd_ptr, gray_rd_ptr_next;
  
  // read write synchronizer pointer
  logic [PTR_WIDTH:0] gray_wr_ptr_sync1, gray_wr_ptr_sync2;
  logic [PTR_WIDTH:0] gray_rd_ptr_sync1, gray_rd_ptr_sync2;
  
  
  // binary to gray code convertion			--- one step ahead before present execution
  // binary pointer updation
  assign bin_wr_ptr_next = bin_wr_ptr + (wr_en && !full);
  assign bin_rd_ptr_next = bin_rd_ptr + (rd_en && !empty);		// pointer updation
  
  // updated pointer binary to gray conversion
  assign gray_wr_ptr_next =  (bin_wr_ptr_next) ^ (bin_wr_ptr_next >> 1);
  assign gray_rd_ptr_next =  (bin_rd_ptr_next) ^ (bin_rd_ptr_next >> 1);	//  binary number ^ (one step logical shifted binary number) --- 1101 ^ 0110
  
  
  // write clock domain 		-- write condition
  always @(posedge wr_clk or negedge wr_rst) begin
    if(!wr_rst) begin
      bin_wr_ptr  <= 0;
      gray_wr_ptr <= 0;
    end
    else begin
      bin_wr_ptr  <= bin_wr_ptr_next;
      gray_wr_ptr <= gray_wr_ptr_next;		// allocating the next pointer to the present pointer for execution
      
      if(wr_en && !full)
        fifo[bin_wr_ptr[PTR_WIDTH-1:0]] <= data_in;		// write into fifo with present ptr address
      				// pointer address without the extra 1 MSB bit 
    end
  end
  
  
  // read clock domain   ---- read condition
  always @(posedge rd_clk or negedge rd_rst) begin
    if(!rd_rst) begin
      bin_rd_ptr  <= 0;
      gray_rd_ptr <= 0;
      data_out    <= 0;
    end
    else begin
      bin_rd_ptr  <= bin_rd_ptr_next;
      gray_rd_ptr <= gray_rd_ptr_next;		// allocating the next pointer to the present pointer for execution
      
      if(rd_en && !empty)
        data_out <= fifo[bin_rd_ptr[PTR_WIDTH-1:0]];		// read into fifo with present ptr address
      						// pointer address without the extra 1 MSB bit 
    end
  end
  
  
  //                           CLOCK DOMAIN CROSSING
  // Synchronize READ pointer into WRITE pointer	--- write clock domain
  always @(posedge wr_clk or negedge wr_rst) begin
    if(!wr_rst) begin
      gray_rd_ptr_sync1 <= 0; 
      gray_rd_ptr_sync2 <= 0;
    end
    else begin
      gray_rd_ptr_sync1 <= gray_rd_ptr; 
      gray_rd_ptr_sync2 <= gray_rd_ptr_sync1;
    end
  end
  
  // Synchronize WRITE pointer into READ pointer   --- read clock domain
  always @(posedge rd_clk or negedge rd_rst) begin
    if(!rd_rst) begin
      {gray_wr_ptr_sync1, gray_wr_ptr_sync2} <= 0;									// another way of implementation using concatenation
    end
    else begin
      {gray_wr_ptr_sync1, gray_wr_ptr_sync2} <= {gray_wr_ptr, gray_wr_ptr_sync1};	// another way of implementation using concatenation
    end
  end
  
  // READ clock domain  --- empty condition
  assign empty = (gray_rd_ptr == gray_wr_ptr_sync2);
  
  // WRITE clock domain --- full condition
  assign full = gray_wr_ptr == ({~(gray_rd_ptr_sync2[PTR_WIDTH : PTR_WIDTH - 1]), (gray_rd_ptr_sync2[PTR_WIDTH-2 : 0])});   	// gray write pointer == {~(sync gray read pointer[MSB] and sync gray read pointer[MSB-1]), remaining sync gray read pointer bits ------  01_100 = (original : 01_100 -- inverted : 10_100)
endmodule

// https://edaplayground.com/x/cD8R
