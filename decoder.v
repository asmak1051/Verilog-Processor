 
module decoder (address,en,word_line); 
    parameter N=4; 
    input [N-1:0] address; 
    input en; 
    //input reg en_n;
    output [2**N-1:0] word_line;
    
    //always @ (en_n)
    //begin
    
    genvar i; 
    generate 
    for (i=0; i<=2**N-1;i=i+1)
    begin  
        assign word_line[i] = (i==address && en==1'b1) ? 1'b1 : 1'b0;
    
    /*
        //if(en_n==0) 
        //begin
            if(i==int(address) && en_n==1'b0) 
            begin
                assign word_line[i] = 1'b1;
            end
            else
            begin
                assign word_line[i]=1'b0;
            end 
        //end
        */
        
    end 
    endgenerate 
    
    //end
endmodule


