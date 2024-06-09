module radix4_comb_tb();

    reg clk;
    reg nd;
    reg signed [31:0] a;
    reg signed [31:0] b;
    wire [63:0] q;

    reg [31:0] counter;
    reg error_flag;

    initial begin
	clk = 0;
	nd = 0;
	a = 0;
	b = 0;
	counter = 0;
	error_flag = 0;
    end

    always begin
      #5 clk <= ~clk;
    end


    always @(posedge clk) begin
	counter <= counter + 1;
	if(counter == 1000) begin
	    if(error_flag == 1) begin
		$display("error");
	    end else begin
		$display("no error");
	    end
	    $finish;
	end else if(counter == 10) begin
	    a <= 10;
	    b <= 20;
	end else if(counter == 11) begin
	    a <= 11;
	    b <= 21;
	end else if(counter == 12) begin
	    a <= -11;
	    b <= -21;
	end else if(counter == 13) begin
	    a <= -11;
	    b <= 21;
	end else if(counter == 14) begin
	    a <= 11;
	    b <= -21;
	end else if(counter == 30) begin
	    a <= 100;
	    b <= 200;
	end

    end

    reg signed [63:0] expected;
    always @(posedge clk) begin
	expected = a * b;
	if(expected != q) begin
	    error_flag <= 1;
	end
    end


    radix4_comb#(.WIDTH(32))
    DUT (
	 .a(a),
	 .b(b),
	 .q(q)
	 );
endmodule // radix4_comb_tb
