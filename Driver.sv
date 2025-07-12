class driver ;
//Section D.1:Define virtual interface, mailbox and packet class handles


//Section D.2: Define variable no_of_pkts_recvd to keep track of packets received from generator

bit [31:0] csr_rdata;

//Section D.3: Define custom constructor with mailbox and virtual interface handles as arguments


//Section D.3.1: Define methods run,drive,drive_reset,drive_stimulus, configure_dut_csr and read_dut_csr as extern methods


endclass

//Section D.7: Define run method to start the driver operations
task driver::run();
$display("[Driver] run started at time=%0t",$time); 

while(1) begin //driver runs forever 
//Section D.7.1: Wait for packet from generator and pullout once packet available in mailbox


$display("[Driver] Received  %0s packet %0d from generator at time=%0t",pkt.kind.name(),no_of_pkts_recvd,$time); 
//Section D.7.2: Process the Received transaction

$display("[Driver] Done with %0s packet %0d from generator at time=%0t",pkt.kind.name(),no_of_pkts_recvd,$time); 
end//end_of_while
endtask

//Section D.6: Define drive method with packet as argument
task driver::drive(packet pkt);
//Section D.6.1: Check the transaction type and call the appropriate method

endtask

//Section D.4: Define drive_reset method with packet as argument


//Section D.5: Define drive_stimulus method with packet as argument
task driver::drive_stimulus(packet pkt);
wait(vif.cb.busy==0);
@(vif.cb);
$display("[Driver] Driving of packet %0d (size=%0d) started at time=%0t",no_of_pkts_recvd,pkt.len,$time);


$display("[Driver] Driving of packet %0d (size=%0d) sa%0d->da%0d ended at time=%0t \n",no_of_pkts_recvd,pkt.len,pkt.inp_stream[0],pkt.inp_stream[1],$time);

endtask

//Section D.8: Define configure_dut_csr method with packet as argument
task driver::configure_dut_csr(packet pkt);
$display("[Driver] Configuring DUT Control registers Started at time=%0t",$time);
@(vif.cb);
vif.cb.wr <= 1;
//Section D.8.1 : Drive pkt.addr onto dut's addr pin
vif.cb.addr  <= pkt.addr; 
//Section D.8.2 : Drive pkt.data onto dut's data pin
vif.cb.wdata <= pkt.data;
@(vif.cb);
vif.cb.wr <= 0;
$display("[Driver] Configuring DUT Control registers Ended at time=%0t",$time);
endtask

//Section D.9: Define read_dut_csr method with packet as argument
task driver::read_dut_csr(packet pkt);
$display("[Driver] Reading DUT Status registers Started at time=%0t",$time);

//Section D.9.1 : Drive pkt.addr onto dut's addr pin

//Section D.9.2 : Receive dut's rdata onto csr_rdata


$display("[Driver] Reading DUT Status registers Ended at time=%0t",$time);
endtask
