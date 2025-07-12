//Section E1 : Include packet,generator,driver,iMonitor,oMonitor and scoreboard classes
`include "packet.sv"
`include "Generator.sv""
`include "Driver.sv"
`include "iMonitor.sv"
`include "oMonitor.sv"
`include "scoreboard.sv"

//Section E2 : Define environment class
class environment;

//Section E3 : Define all components class handles
generator gen;
driver drvr;
iMonitor mon_in;
oMonitor mon_out;
scoreboard scb;

//Section E4 : Define Stimulus packet count
bit [15:0] no_of_pkts;//assigned in testcase
bit env_disable_report;
bit env_disable_EOT;

//Section E5 : : Define mailbox class handles
//Below will be connected to generator and driver(Generator->Driver)
mailbox #(packet) gen_drv_mbox;
//Below will be connected to input monitor and mon_in in scoreborad (iMonitor->scoreboard)
mailbox #(packet) mbx_iMon_scb;
//Below will be connected to output monitor and mon_out in scoreborad (oMonitor->scoreboard)
mailbox #(packet) mbx_oMon_scb;

//Section E6 : : Define virtual interface handles required for Driver,iMonitor and oMonitor
virtual router_if.tb_mod_port vif;
virtual router_if.tb_mon vif_mon_in;
virtuak router_if.tb_mon vif_mon_out;

//Section E7: Define custom constructor with virtual interface handles as arguments and pkt count
function new (input virtual router_if.tb_mod_port vif_in,
		input virtual router_if.tb_mon vif_mon_in,
		input virtual router_if.tb_mon vif_mon_out,
		input bit [31:0] no_of_pkts)
	this.vif = vif_in;
	this.vif_mon_in=vif_mon_in;
	this.vif_mon_out=vif_mon_out;
	this.no_of_pkts = no_of_pkts;
endfunction
//Section E8: Build Verification components and connect them.
function void build();
$display("[Environment] build started at time=%0t",$time); 
//Section E8.1: Construct objects for mailbox handles.
gen_drv_mbox = new(1);
mbx_iMon_scb = new;
mbx_oMon_scb = new;
//Section E8.2: Construct all components and connect them.
gen = new(gen_drv_mbox,no_of_pkts);
drvr = new(gen_drv_mbox,vif);
mon_in = new(mbx_iMon_scb, vif_mon_in);
mon_out = new(mbx_oMon_scb,vif_mon_out);
scb = new(mbx_iMon_scb,mbx_oMon,scb);
$display("[Environment] build ended at time=%0t",$time); 
endfunction

//Section E9: Define run method to start all components.
task run ;
$display("[Environment] run started at time=%0t",$time); 
//Section E9.1: Call build method which contruct the components and connects them
//Section E9.2: Start all the components of environment
fork
gen.run();
drvr.run();
mon_in.run();
mon_out.run();
scb.run();
join_any

//Section E9.3 : Wait until scoreboard receives all packets from iMonitor and oMonitor
if(!env_disable_EOT)//end of test
	wait(scb.total_pkts_recvd == no_of_pkts);

repeat(5) @(vif.cb);//drain time

//Section E9.4 : Print results of all components

if(!env_disable_report) report();

$display("[Environment] run ended at time=%0t",$time); 
endtask

//Section E10 : Define report method to print results.
function void report();
$display("\n[Environment] ****** Report Started ********** "); 
//Section E10.1 : Call report method of iMon,oMon and scoreboard
mon_in.report();
mon_out.report();
scb.report();
$display("\n*******************************"); 
//Section E10.2 : Check the results and print test Passed or Failed
if(scb.m_mismatched ==0 && (no_of_pkts == scb.total_pkts_recvd))
	$display("********Test Passed************");
else begin
	$display("********Test Failed************");
end
$display("*************************\n "); 
$display("[Environment] ******** Report ended******** \n"); 
endfunction

endclass
