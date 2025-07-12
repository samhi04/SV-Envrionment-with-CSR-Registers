//Section T1 : Define new_test1 extends from base_test
class new_test1 extends base_test;

//Section T2 : Define new_pkt habdle of type new_packet
new_packet new_pkt;

//Section T3: Define custom constructor with virtual interface handles as arguments.
function new (input virtual router_if.tb_mod_port vif_in,
              input virtual router_if.tb_mon  vif_mon_in,
              input virtual router_if.tb_mon  vif_mon_out
	          );

//Section T4: Call base class custom constructor with virtual interface handles as arguments.
super.new(vif_in, vif_mon_in, vif_mon_out);

endfunction

//Section T5: Define run method to start Verification environment.
virtual task run();
$display("[new_test1] run started at time=%0t",$time);

//Section T5.1: Construct object for new_pkt handle.
new_pkt = new();

//Section T5.2: Decide number of packets to generate in generator
no_of_pkts = 10;

//Section T5.3: Construct objects for environment and connects intefaces.
build();

//Section T5.4 : Pass new_packet oject to Generator.
//Handle assignment packet=new_packet(b=d);
env.gen.ref_pkt = new_pkt;

//Section T5.5: Start the Verification Environment
env.run();

$display("[new_test1] run ended at time=%0t",$time);
endtask


endclass
