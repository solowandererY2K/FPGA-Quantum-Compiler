module FPGACompiler(
  input [18:0] a,
  input [18:0] b,
  output [18:0] result
);
  fixmul(a, b, result);
endmodule // top
