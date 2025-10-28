class nvme_txn extends uvm_sequence_item;
    `uvm_object_utils(nvme_txn)
    
    nvme_cmd_s cmd;
    logic [CQE_BITS-1:0] expected_cqe_bits;
    int unsigned expected_status;
    string test_name;
    function new(string name="nvme_txn");
      super.new(name);
      expected_status = 0;
    endfunction
    // pack/unpack for printing
    function string convert2string();
      return $sformatf("cmd.op=0x%0h cid=%0d nsid=%0d prp1=0x%0h prp2=0x%0h",
        cmd.opcode, cmd.cid, cmd.nsid, cmd.prp1, cmd.prp2);
    endfunction
    
endclass
