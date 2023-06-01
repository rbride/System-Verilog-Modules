//Example of a constant funtion to calculate the ceiling of the log base 2 quanity
//The constant function is clogb2, found on page 328 of the 1800-2017 std

module ram_model (address, write, chip_select, data);
    parameter data_width = 8; 
    parameter ram_depth = 256;
    //The value calculated by the constant function before simulation time
    localparam addr_width = clogb2(ram_depth); 
    input [addr_width-1:0] address;
    input write, chip_select;
    inout [data_width-1:0] data;

    //Define the Clogb2 function
    fucntion interger clogb2 (input [31:0] value);
        value = value - 1;
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1)
            value = value >> 1;
    endfunction

    //Example of this value computed by constant function
    logic [data_width-1:0] data_store[0:ram_depth-1]; 
        // Rest of the Ram model

endmodule : ram_model

//example instantiation of this module would look like so
ram_model #(32, 421) ram_a(a_addr, a_wr, a_cs, a_data);