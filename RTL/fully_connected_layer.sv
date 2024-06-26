//Author: Akshat Mathur
//Code revisions:

//Initializing all neurons with same weight
//TODO add Backprop code here
(* keep_hierarchy = "yes" *)module fully_connected_layer #(parameter IP_DATA_WIDTH=8, IP_LAYER_NEURONS=4, ACT_FN="RELU", NUM_IP=1, ACT_FN_SIZE=5,DENSE_LAYER=1,DENSE_LAYER_NEURONS=2) 
//import yolo_params_pkg::*;
(
    input clk,
    input rst,
    input signed [2*IP_DATA_WIDTH-1:0] x [(IP_LAYER_NEURONS*NUM_IP)-1:0],
    input signed [2*IP_DATA_WIDTH-1:0] wt_in [(IP_LAYER_NEURONS*NUM_IP)-1:0],
    input signed [2*IP_DATA_WIDTH-1:0]wt_temp[IP_LAYER_NEURONS],
    input signed [2*IP_DATA_WIDTH-1:0]wt_dense[DENSE_LAYER_NEURONS],
    input update_wts,
    output signed [2*IP_DATA_WIDTH-1:0] out

);

bit signed [2*IP_DATA_WIDTH-1:0]out_temp[IP_LAYER_NEURONS-1:0];
bit signed [2*IP_DATA_WIDTH-1:0]out_dense[DENSE_LAYER_NEURONS-1:0];

genvar i,j,k,l;

generate
  for(i=0; i< IP_LAYER_NEURONS; i++)
  begin
(* keep_hierarchy = "yes" *) neuron #(.ACT_FN("RELU"), .NUM_IP(NUM_IP), .ACT_FN_SIZE(ACT_FN_SIZE), .DENSE_LAYER(DENSE_LAYER), .DENSE_LAYER_NEURONS(DENSE_LAYER_NEURONS)) inst_1
      (
          .clk(clk),
          .rst(rst),
          //.x(x[(i*NUM_IP)-1:NUM_IP*(i-1)]) ,
          //.wt_in(wt_in[(i*NUM_IP)-1:NUM_IP*(i-1)]) ,
          .x(x[((i+1)*NUM_IP)-1:NUM_IP*i]) ,
          .wt_in(wt_in[((i+1)*NUM_IP)-1:NUM_IP*i]) ,
          .update_wts(update_wts),
          .out(out_temp[i])

      );
  end
endgenerate

generate

//  for(j=1; j<= DENSE_LAYER; j++) // j=1
//  begin
      for(k=0; k< DENSE_LAYER_NEURONS; k++) //k=2
      begin
(* keep_hierarchy = "yes" *) neuron #(.ACT_FN("RELU"), .NUM_IP(IP_LAYER_NEURONS), .ACT_FN_SIZE(ACT_FN_SIZE), .DENSE_LAYER(DENSE_LAYER), .DENSE_LAYER_NEURONS(DENSE_LAYER_NEURONS)) inst_2
          (
              .clk(clk),
              .rst(rst),
              .x(out_temp) ,
              .wt_in(wt_temp) ,
              .update_wts(update_wts),
              .out(out_dense[k])
          );

      end
 // end

 
(* keep_hierarchy = "yes" *) neuron #(.ACT_FN("RELU"), .NUM_IP(DENSE_LAYER_NEURONS), .ACT_FN_SIZE(ACT_FN_SIZE), .DENSE_LAYER(DENSE_LAYER), .DENSE_LAYER_NEURONS(DENSE_LAYER_NEURONS)) inst_3
 (
     .clk(clk),
     .rst(rst),
     .x(out_dense) ,
     .wt_in(wt_dense) ,
     .update_wts(update_wts),
     .out(out)
 );
  
endgenerate


endmodule
