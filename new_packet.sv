//Section 1 : Define new_packet extends from original packet
class new_packet extends packet;

//Section 2 : Define constraints to generate scenario specific stimulus
constraint valid {

//Section 3 : Constraint sa and da to be in the range 2 to 4
sa inside {[2:4]};
da inside {[2:4]};

//Section 4 : Constraint payload size to be in the range 101 to 200
payload.size() inside {[101:200]};

}

endclass
