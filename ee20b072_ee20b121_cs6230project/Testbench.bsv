package Testbench;
import FPAdder64 ::*;

(* synthesize *)
module mkTestbench (Empty);
    FPAdder64_ifc mod <- mkFPAdder64;

    rule rl_go;
       mod.put_A(64'b1100000001011001100011001100110011001100110011001100110011001101);// -102.2
       mod.put_B(64'b0100000000100111000000000000000000000000000000000000000000000000);// 11.5
    endrule

    rule rl_finish;
        let res = mod.get_res();

        $display("\ntime at which it completed - %0t", $time);
        $display("(-102.5 + 11.5) = %h", res);
        $finish();
    endrule

endmodule: mkTestbench
endpackage

