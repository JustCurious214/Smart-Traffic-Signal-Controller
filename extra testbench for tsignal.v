`timescale 1s/1ms

module tb_t_Signal;

  reg clk = 0;
  reg emergency_right = 0;
  reg emergency_left = 0;
  wire [1:0] T1;
  wire [1:0] T2;
  wire Verification;
  wire verification1;
  wire ped_0;
  wire ped_1;
  wire buzzer;
  wire buzzer1;

  // Instantiate the module under test (MUT)
  t_Signal uut (
    .clk(clk),
    .emergency_right(emergency_right),
    .emergency_left(emergency_left),
    .T1(T1),
    .T2(T2),
    .Verification(Verification),
    .verification1(verification1),
    .ped_0(ped_0),
    .ped_1(ped_1),
    .buzzer(buzzer),
    .buzzer1(buzzer1)
  );

  // Clock generation (toggle every 0.5s => 1s period)
  always #0.5 clk = ~clk;

  // Test sequence
  initial begin
    $display("Time\tT1\tT2\tE_right\tE_left\tVerif\tPed0\tBuz0\tPed1\tBuz1");
    $monitor("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
             $time, T1, T2, emergency_right, emergency_left, Verification, ped_0, buzzer, ped_1, buzzer1);

    // Let the system run
    #500;

    // Wait until Light is RED (count % 20 < 10)
    wait (uut.count % 20 < 10);
  #500;
    // Trigger emergency during RED phase
    $display("\n=== Emergency triggered during RED ===");
    emergency_right = 1;

    #500;
    emergency_right = 0;

    // Allow system to run for recovery
    #1000;

    $display("\n=== End of simulation ===");
    $finish;
  end

  // VCD Dump
  initial begin
    $dumpfile("t_Signal.vcd");
    $dumpvars(0, tb_t_Signal);
  end

endmodule
