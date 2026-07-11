// Code your design here
`timescale 1s/1ms

module t_Signal(
  input wire clk,
  input wire emergency_right,
  output reg [1:0] T1,
  output reg Verification,
  output reg[1:0] T2,
  input emergency_left,
  output reg verification1,
  output reg ped_0,//line of chabge,
  output reg buzzer,
  output reg buzzer1,
  output reg ped_1//line of change
);

  
  //These are the variables needed because we cannot use the output values in the conditional statemet
  reg pedistrian1  = 1'b1;
  reg pedistrian = 1'b1;
  
  
  //These are the variables to keep trac on the emergency left and emergency right to be used in conditional satatements
  reg validate = 1'b0;
  reg validate1 = 1'b0;
  
  assign ped_0 = pedistrian;
  assign ped_1 = pedistrian1;
  
  //These registers keep track of the time to be in a state even if emergency input is triggered
  reg [7:0] count = 8'b00000000;
  reg [7:0] count1 = 8'b0000100 ;
  reg [7:0] values = 8'b00000000;
  reg [7:0] values1 = 8'b00000000;
  reg[7:0] values2 = 8'b00000000;
  
  reg in_yellow = 0;
  reg in_yellow1 = 0;
  reg emergency_check = 1'b0;
  reg [1:0]prev_Light1;
  reg [1:0]prev_Light;
 reg state = 1'b0;
   //These are the threestates in the Traffic light
  localparam red    = 2'b00;
  localparam green  = 2'b11;
  localparam yellow = 2'b01;
  
  //these are used as tick boxes to excecute or donnot excecute an pricedurla blok
  localparam stay =1'b1;
localparam leave =1'b0;
  //checks if emergency left input is triggered
  always @(posedge clk) begin
    if (emergency_right == 1'b1 || in_yellow) begin
      T1 <= red;
      T2 <=red;
      emergency_check = 1'b1;
      Verification <= 1'b1;
      validate <= 1'b1;
      values <= values + 1;
      values1 <= values1 +1;
      in_yellow <= 1;
      //in yellow is the vvariabe that stays for the amout of time till emergency is triggered for 4 units
//waits for 4 time units then resets teh variable value to 0
      //Basically in_yellow ane in_yellow1 kepps tracks if the cirrent state is emergency or not
      if (values == 8'd9) begin
        values <= 0;
        values1 <=0;
        in_yellow <= 0;
        emergency_check = 1'b0;
      end
    end 
    else if(emergency_left == 1'b1||in_yellow1)begin
      T1 <= red;
      verification1<= 1'b1;
        validate1 <= 1'b1;
      values2<=values2+1;
      in_yellow1 <= 1'b1;
      emergency_check = 1'b1;
      if(values2 == 8'd9) begin
      values2 <=0;
        in_yellow1 <= 1'b0;
        emergency_check = 1'b0;
        
      end
    end
    //else verification variable and validate variable should be in the normal state 0
    
    
    //THE main logic is that count keeps track of the current state,when count is divided by 20 if remainder is less than 10 it is red, if remainder is inbetween 10 to 15 it is geen and remainder from 15 to 20 is yello
    else begin
      Verification <= 1'b0;
      validate <=1'b0;
      count <= count + 1;
      count1<=count1+1;
		verification1 <= 1'b0;
      validate1 <= 1'b0;
      if (count % 95 < 60)
        T1 <= red;
      else if(count %95 < 90 && count %95 >=60)
        T1 <= green;
      else if(count % 95 >=90 )
        T1 <= yellow;
      
      
      //same logic for the second traffic signal
      
      if (count1 % 95 < 60)
        T2 <= red;
      else if(count1 %95 < 90 && count1 %95 >=60)
        T2 <= green;
      else if(count1 % 95 >=90 )
       T2 <= yellow;
      
    end
//assigning prev_Light as light the is used to keep track of the previous light
prev_Light1 = T2;
    prev_Light = T1;
  end//biggest procedural block end
  
  always @(emergency_right) begin
    if(emergency_right == 1) state = leave;
    else state = stay;
  end
  always @(T2 or prev_Light1 ) begin
    //TO make the pedistrian red when it emergency input is triggered
    if(validate == 1'b1 || emergency_right == 1'b1)begin
      pedistrian1 = 1'b0;
    end
    else if(validate1 == 1'b0  || emergency_left == 1'b0)begin
    if(prev_Light1 == yellow ) begin
      if(T2 == red) pedistrian1 = 1'b1;
    end
    if(prev_Light1 == red) begin
      if(T2 != red) pedistrian1 = 1'b0;
    end
    end
    if(validate1 == 1'b1 || emergency_left == 1'b1)
      begin
        pedistrian1 =1'b0;
      end
    if(emergency_check == 1'b0 && T2 == red)begin
      pedistrian1 = 1'b1;
    end
    

      
  end
  
//   always @(values2)begin
  //     if(values2==1'b0) begin
  always @(T1 or prev_Light or emergency_check ) begin
    if(validate == 1'b0 || emergency_right == 1'b0)begin
    if(prev_Light == yellow ) begin
      if(T1 == red) pedistrian = 1'b1;
    end
    if(prev_Light == red ) begin
      if(T1 != red) pedistrian = 1'b0;
    end
      if(validate ==1'b1 || emergency_right == 1'b1) begin
        pedistrian = 1'b0;
        
      end
      
      if(emergency_check == 1 ||emergency_left ==1'b1 || emergency_right == 1'b1)begin
        pedistrian = 1'b0;
      end
//       if(emergency_check == 1'b0 && T2 == red)begin
//       pedistrian = 1'b1;
//     end
    
    end
    //Logic for buzzer is to be high when it is red(ending state) and when their is no ambulance
    
  end
  always @(count)begin
    if(((count%95) > 55 && (count%95) < 61) && pedistrian == 1'b1) buzzer = 1'b1;
    else buzzer = 1'b0;
  end
  always @(count1)begin
    if(((count1%95)  > 55 &&(count1%95) <61 ) && pedistrian1 == 1'b1) buzzer1 = 1'b1;
    else buzzer1 = 1'b0;
  end
    
endmodule


`timescale 1s/1ms

module tb_example;

  // Testbench signals
  reg clk;
  reg emergency_right;
  reg emergency_left;
  wire [1:0] T1;
  wire Verification;
  wire [1:0] T2;
  wire verification1;
  wire ped_0;     // pedestrian signal for T1
  wire buzzer;
  wire buzzer1;
  wire ped_1;     // pedestrian signal for T2

  // Instantiate the DUT
  t_Signal uut (
    .clk(clk),
    .emergency_right(emergency_right),
    .emergency_left(emergency_left),
    .T1(T1),
    .Verification(Verification),
    .T2(T2),
    .verification1(verification1),
    .ped_0(ped_0),
    .buzzer(buzzer),
    .buzzer1(buzzer1),
    .ped_1(ped_1)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 ms clock period
  end

  // Stimulus generation
  initial begin
    // Initial conditions
    emergency_right = 0;
    emergency_left = 0;

    // Test Case 1: Normal Operation
    #900 emergency_right = 0; emergency_left = 0;
    #10 emergency_right = 1; // Simulate emergency signal
    #200 emergency_right = 0;  // End emergency signal

    // Test Case 2: Emergency Left signal triggered
    #700 emergency_left = 1; // Trigger emergency_left
    #200 emergency_left = 0; // End emergency_left signal

    // Test Case 3: Testing pedestrian logic
    #200 emergency_right = 0; emergency_left = 0;
    #100; // Let the system run
    #500;

    // Test Case 4: Resume normal traffic
    #20 emergency_right = 0; emergency_left = 0;
    #100;
    #150;

    // End simulation
    #200 $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("Time=%t T1=%b T2=%b Verification=%b verification1=%b ped_0=%b ped_1=%b buzzer=%b buzzer1=%b", 
              $time, T1, T2, Verification, verification1, ped_0, ped_1, buzzer, buzzer1);
  end

  // Waveform dump
  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb_example);
  end

endmodule
