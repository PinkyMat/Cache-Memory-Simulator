// Parameters to be modified : Cache sizes
`define CACHE_SIZE 1000
`define LINE_SIZE 32
`define SET_ASSOCIATIVITY 8
// Extracting Address Format
`define INDEX
(`SET_ASSOCIATIVITY==0)?0:$clog2(`CACHE_SIZE/(`LINE_SIZE*`SET_ASSOCIATIVITY))
`define OFFSET $clog2 (`LINE_SIZE)
`define TAG 31-(`OFFSET+`INDEX)
module cachesimulator(Address_10,Clock_10,Reset_10,CacheMiss_10,CacheHit_10);
input Clock_10, Reset_10;
input [30:0] Address_10;
output [30:0] CacheMiss_10,CacheHit_10;

integer i,j,k;
reg [30:0]
BlockNum_10,SetNum_10,CacheMiss_10,CacheHit_10,cache_block_10,cache_set_10,set_index_
10,Current_Block_10,Current_Count_10;
reg data_10;

parameter CACHE = `CACHE_SIZE;
parameter LINE = `LINE_SIZE;
parameter A = (`SET_ASSOCIATIVITY == 0)?(CACHE/LINE):`SET_ASSOCIATIVITY;
parameter O = `OFFSET;
parameter IDX = `INDEX;
parameter T = `TAG;

reg [(LINE*8)-1:0] cache [0:(CACHE/LINE) - 1];
reg [T-1:0] tag_array [0:(CACHE/LINE) - 1]; //TAGBITS
reg valid_array [0:(CACHE/LINE) - 1]; //VALID ARRAY


 reg [T-1:0] tag; // for current tag
 reg [A-1:0] counter [0:(CACHE/LINE) - 1];

initial begin
 CacheHit_10 = 0;
 CacheMiss_10 = 0;
 BlockNum_10 = CACHE/LINE;
 SetNum_10 = BlockNum_10/A;

 for (k = 0; k < BlockNum_10 ; k = k + 1)
begin
 valid_array[k] = 0;
 tag_array[k] = 0;
end
 for (j = 0; j < SetNum_10 ; j = j + 1)
 for (k = 0; k < A ; k = k + 1)
 counter[(j*A)+k] = k;

 end
always@(posedge Clock_10)begin

 cache_block_10 = (Address_10/LINE)% BlockNum_10;
 cache_set_10 = ((Address_10/LINE)% (BlockNum_10/A));
 set_index_10 = cache_set_10*A; // POINTER POINTING TO FIRST BLOCK OF CURRENT
SET
 data_10 = 0;

 tag = Address_10[30:(O+IDX)];

 for(i=0; i<A; i=i+1) begin
 if ((valid_array [set_index_10+i] == 1) && (tag == tag_array[set_index_10+i])) begin
 CacheHit_10 = CacheHit_10+1;
 data_10 = 1;
 Current_Block_10 = set_index_10+i;
 Current_Count_10 = counter[Current_Block_10];
 $display("CacheHit_10=%d",CacheHit_10);
 end
 end

 if (data_10 == 0) begin
 CacheMiss_10 = CacheMiss_10+1;
 $display("CacheMiss_10=%d",CacheMiss_10);

 for(i=0; i<A; i=i+1) begin
 if (counter[set_index_10+i]==0)begin
 tag_array[set_index_10+i] = tag;
 valid_array [set_index_10+i] = 1;
 Current_Block_10 = set_index_10+i;
 Current_Count_10 = 0;
 end
 end
 end

 for(i=0; i<A; i=i+1) begin // counter

 if (counter[set_index_10+i]>Current_Count_10)begin
 counter[set_index_10+i] = counter[set_index_10+i] - 1;
 end

 counter[Current_Block_10] = A - 1 ;

 end

 end
endmodule
