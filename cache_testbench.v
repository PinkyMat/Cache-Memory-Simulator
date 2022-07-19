module cachesimulator_tb();
reg clock_10, reset_10;
reg [30:0] address_10;
wire [30:0] cachemiss_10, cachehits_10;
real hitratio_10, percntage_10 = 100.00;
real miss_10, hit_10;
`define TotalAddress 1500000
integer file1,stat,out,i,j;
reg signed [30:0] offset[0:`TotalAddress-1];
reg [30:0] ActualAdress[0:`TotalAddress-1];
cachesimulator dut1(address_10,clock_10, reset_10,cachemiss_10,cachehits_10);
initial
begin
file1=$fopen("addr_trace.txt","r");
 i=0;
 while(! $feof(file1)
begin
stat=$fscanf(file1,"%d\n",offset[i]);
 i=i+1;
end
$fclose(file1);

for(i=0;i<`TotalAddress;i=i+1)
begin
if (i==0)
ActualAdress[0] = offset[0];
 else
ActualAdress[i]=ActualAdress[i-1]+offset[i];

 end
end
always #5 clock_10 = ~clock_10;
initial
begin
clock_10 = 0;

for (j = 0 ; j<`TotalAddress ; j=j+1)
begin
@(posedge clock_10) address_10 = ActualAdress[j];
 end
 @(posedge clock_10)
miss_10=cachemiss_10;
hit_10=cachehits_10;
hitratio_10 = (hit_10/(miss_10 + hit_10))*percntage_10;
$display("Hit Ratio=%7.2f, Cache Hits = %d, Total Simulation Addresses =
%d",hitratio_10,cachehits_10 ,(cachemiss_10 + cachehits_10));

$finish;
end
endmodule
