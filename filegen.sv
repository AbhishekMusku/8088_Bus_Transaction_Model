module write_random_data_to_text_file;

  // Define parameters
  parameter NUM_LINES =802; // Number of lines in the text file
  
  // Function to generate random 8-bit hexadecimal value
  function automatic string random_hex_value;
    string hex_str;
    $sformat(hex_str, "%2h", $urandom_range(256)); // Generate random 8-bit hexadecimal value
    return hex_str;
  endfunction
  
  // Main module
  initial begin
    // Open file for writing
    automatic string filename = "I01.txt";
    int file_handle;
    file_handle = $fopen(filename, "w");
    
    // Check if file is opened successfully
    if (file_handle == 0) begin
      $display("Error: Could not open file '%s' for writing", filename);
      $finish;
    end
    
    // Write random data to file
    repeat (NUM_LINES) begin
      automatic string hex_value = random_hex_value();
      $fwrite(file_handle, "%s\n", hex_value);
    end
    
    // Close file
    $fclose(file_handle);
    
    $display("Random data has been written to file '%s'", filename);
  end
  
endmodule
