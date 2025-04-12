/*
This bidirectional buffer allows two-way communication between a and b, controlled by the cntrl signal.
*/
// Bidirectional Buffer Module
module bidir_buffer(
    inout a,     // Bidirectional signal 'a'
    inout b,     // Bidirectional signal 'b'
    input cntrl  // Control signal for direction
    );

    // When `cntrl` is 1, data flows from `a` to `b`
    bufif1 BUF1(b, a, cntrl);

    // When `cntrl` is 0, data flows from `b` to `a`
    bufif1 BUF2(a, b, ~cntrl);

endmodule

