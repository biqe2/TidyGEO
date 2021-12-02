tabPanel(title = SHIFT_ICON, value = "2",
         h4("Extract shifted values"),
         p('Sometimes, missing values can cause data values to be scattered across multiple columns (such as "Sex" and "Freq" in ', 
           actionLink(inputId = "show_broken_cols_example", label = "this example"),
           '). This makes it difficult to extract data for the single variable.'),
         p("Here, you can identify columns that have scattered values and extract values matching a common pattern into a new column." 
           ),
           

   #based on num 3 split pairs        
         tags$b("Please select columns that have values that you want to extract:"),
                                                            #help_link("clinical", "split_help")),

                          checkboxInput(inputId = "select_all_shift", 
                                        label = tags$i("Select all")),
                          uiOutput("choose_cols_to_shift"),
                          textInput(inputId = "shift_pattern", label = "Pattern (including any spaces): ", placeholder = "Start typing..."),
                          textInput(inputId = "new_col_name", label = "New column name:", placeholder = "Start typing...")
         #)
         ,
         div(p(
           'You can use regular expressions for this tool', regex_help_link("clinical", "split_pairs")
         )), 
         
              
         div(
           primary_button(id = "shift_pairs", label = div(SHIFT_ICON, "Shift Columns")),
           undo_button("undo_shift")
         ),     
              
         hr(), navigation_set("1", "2", "3", "clinical_side_panel", "clinical_side_panel")
         )
