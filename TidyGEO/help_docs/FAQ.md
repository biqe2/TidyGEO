### <a name="contents"></a>Contents

1. [Importing the data](#importing-the-data)
2. [General questions](#general-questions)
3. [Clinical data](#clinical-data)
    + [Selecting informative columns](#selecting-informative-columns)
    + [Shifting cells](#shifting-cells)
    + [Splitting pairs and splitting columns](#splitting-pairs-and-splitting-columns)
    + [Renaming columns](#renaming-columns)
    + [Substituting values](#substituting-values)
    + [Excluding variables](#excluding-variables)
4. [Assay data](#assay-data)
    + [Formatting the assay data](#formatting-the-assay-data)
5. [R scripts](#r-scripts)
6. [Bugs and suggestions](#bugs-and-suggestions)
    
### <a name="importing-the-data"></a>Importing the data

* __What is a series?__
    + GEO is a database of experiments that scientists have uploaded to share publicly. One of the ways the experiments are organized is in a Series. A Series is a set of experiments that are closely related. They often pertain to a specific study. If you visit the page for any GEO Series, you can find a link to PubMed where the study has been published.
* __How long should a series take to load?__
    + Normally, a series loads in under 10 minutes. The largest ones may take to 45-90 minutes to load. If the series takes over 10 minutes to load, it is likely too large for TidyGEO to handle. You may consider using the <a href="https://bioconductor.org/packages/release/bioc/html/GEOquery.html" target="_blank">GEOquery R package</a> to handle the series instead.
* __What does "Trouble establishing connection to GEO. Please try again later" mean?__
    + Your GEO ID is likely in the right format, but it doesn't exist on GEO. 
    + Try searching for that dataset on <a href="https://www.ncbi.nlm.nih.gov/gds/" target="_blank">GEO</a> to see if it actually exists. If you're sure it does, try refreshing the app. 
    + Please make sure to use the identifier that starts with "GSE" (see the Series section on <a href="https://www.ncbi.nlm.nih.gov/books/NBK159736/" target="_blank">this page</a>).
* __What does "File not found. Please enter a valid ID" mean?__
    + Your GEO ID is probably not in the right format. 
    + Try searching for that dataset on <a href="https://www.ncbi.nlm.nih.gov/gds/" target="_blank">GEO</a> to see if it actually exists. Then copy and paste the identifier for that dataset into the text field. 
    + Please make sure to copy the identifier that starts with "GSE" (see the Series section on <a href="https://www.ncbi.nlm.nih.gov/books/NBK159736/" target="_blank">this page</a>). 
    + Please make sure the ID doesn't have any extra characters (spaces, dashes, etc).
    + If you are certain your GEO ID exists, there may be some issues with GEO itself: sometimes the website goes down for maintenance. Try visiting <a href="https://www.ncbi.nlm.nih.gov/geo/" target = "_blank">GEO's website</a> to see if it has any trouble loading.
* __Why isn't the reset button doing anything?__
    + "Reset" restores the data to its original format upon being downloaded. If there haven't been any changes to the data, nothing will happen.

[&uarr; To top](#contents)


### <a name="general-questions"></a>General questions

* __I am pressing Undo over and over and nothing is happening.__
    + Undo only goes back *one* operation. To undo more than one operation, you will likely have to Reset the data and start again.
* __What should my data look like after I am finished?__
    + This depends entirely on the research question you are trying to answer. It is usually helpful to put the data in _tidy_ format, which, according to data scientist Hadley Wickham, means that:
        1.  Each variable must have its own column.
        2.  Each observation must have its own row.
        3.  Each value must have its own cell.
<img src="https://d33wubrfki0l68.cloudfront.net/6f1ddb544fc5c69a2478e444ab8112fb0eea23f8/91adc/images/tidy-1.png" width = 100%>
    + To read more about tidy data, read Hadley Wickham's <a href = "https://vita.had.co.nz/papers/tidy-data.pdf" target = "_blank">paper</a> (a general guide to tidy data) or his <a href = "https://r4ds.had.co.nz/tidy-data.html" target = "_blank">help guide</a> (which is more specialized towards the R language).
* __What can I do with my data after I have reformatted it?__
    + You can download it onto your computer and load it into an analysis software of your choice.
    + <a href="https://brb.nci.nih.gov/BRB-ArrayTools/index.html" target="_blank">BRB-ArrayTools</a> is a package with an Excel add-in that can be used to analyze Microarray gene expression, copy number, methylation and RNA-Seq data.
    + <a href="https://gdancik.shinyapps.io/shinyGEO/" target="_blank">shinyGEO</a> is an application specializing in differential expression analysis and survival analysis for GEO datasets.
* __How can I find the difference between the current version of TidyGEO and the previous version?__
    + Short descriptions of changes are located in the About section of this application.
    + FOr more detailed information about version changes, visit <a href = "https://github.com/srp33/TidyGEO" target = "_blank">TidyGEO's GitHub page</a> and look at the commit messages. Whenever a file is changed, the author adds a message providing an explanation for the change.
    + Most of the time, the scripts generated by different versions of TidyGEO are compatible with each other. If you find that your R script is experiencing errors, it may be helpful to either generate a new script using the latest version of TidyGEO or copy and paste the helper functions from the latest version of TidyGEO to replace the old functions in the script.

[&uarr; To top](#contents)

    
### <a name="clinical-data"></a>Clinical data

* __What is clinical data?__
    + This data describes the samples that were used in the study. Each sample has an ID starting with “GSM”. The clinical data may include information about treatments (e.g. case vs control), demographic information (e.g. male vs female) or information about the experiment itself (e.g. the research institution). Knowing clinical information about a sample can be useful in interpreting patterns in the assay data. For example, if you know which samples are the cases and which are the controls, you can look at the differences between their assay measurements.
    
#### <a name="selecting-informative-columns"></a>Selecting informative columns
* __I selected some preset filters to remove columns from the data, but after I clicked "Filter columns", nothing happened. Why?__
    + The filters you selected would have dropped all the columns from the table, so no columns were dropped. Try unselecting one of the filters and clicking "Filter columns" again.
    + The "Is unique" filter is usually the culprit. Try unselecting this filter and clicking "Filter columns" again.

#### <a name="shifting-cells"></a>Shifting cells
* __Does the order in which I shift the values into a different column matter?__
    + Yes. For most datasets, the problem arises when `NA` values cause the remaining values in the row to shift over. To fix this, it is important to shift all of the cells that belong in the last column first, and then work your way left until the values are all in the desired columns.
* __If I made a mistake while shifting, can I shift the values back?__
    + Most likely, yes. You can also press the "Undo" button.

#### <a name="splitting-pairs-and-splitting-columns"></a>Splitting pairs and splitting columns
* __It says that the column has cells that don't contain the delimiter, but I can see that they do. How do I fix this?__
    + Take note of the rows and the values in the error message, and in the substitute values tab (tab 4), fix those values to have the same delimiter as the rest of the column. 
    + If the culprit is missing values ("NA", "?", "-" , etc.), you will have to substitute those values for NA. 
    + Then, try pressing either "Split pairs" or "Split columns" again.
* __Why are my columns disappearing?__
    + Columns that are identical (have all the same values in the same positions) are automatically filtered out every time you make a change.
* __What is the difference between splitting key-value pairs and splitting a column?__
    + Splitting key-value pairs will assign the key (the thing before the delimiter) to the column name, and the value (the thing after the delimiter) will remain as it is in the column.
    + Splitting a column will make multiple columns out of one column, each with a different value that was separated by the delimiter.
    + Usually data with one ":" or "=" in the column indicates a key-value pair, and data with one or more of ",", or ";" indicates a column with multiple values.
* __I tried to split a column into more columns, but it put the first value as the title of the column. What happened?__
    + You probably split key-value pairs instead of splitting the column. Try this again in the next tab over.
* __I would like to do the _opposite_ of splitting a column, i.e., I would like to combine two columns. How do I achieve this?__
    + You can use the "Shift cells" functionality to combine columns.
* __I tried to split key-value pairs and the application crashed. What happened?__
    + If multiple columns in your data have the same key (i.e., the value before the delimiter), splitting these columns will create duplicate column names, which is not allowed. To prevent this from happening, change the keys to be unique for each column using the "Substituting values" tab. After splitting, you can combine the columns using "Shift cells" if they all describe the same variable.
* __It said there is an error and that I should leave the regex option unchecked, but the regex option _is_ unchecked. What am I doing wrong?__
    + There could be a number of issues causing this problem.
    + You could try using the regex tester (in the link under "Use regex") to see if your delimiter is actually splitting where you think it should. Once you've tested your delimiter, make sure to click the "Split" button again _with the regex option selected_ (this will give you the same result as what you viewed in the regex tester).
    + If you're still having problems, please feel free to <a href="https://github.com/srp33/TidyGEO/issues" target="_blank">open an issue on the GitHub page.</a>

#### <a name="renaming-columns"></a>Renaming columns
* __Why do the column names have periods in them after I have renamed them?__
    + There are certain rules in R (the language the app is built upon) that regulate how columns can be named. 
    + See the Details section of <a href="https://stat.ethz.ch/R-manual/R-devel/library/base/html/make.names.html" target="_blank">this webpage</a> for details on what kinds of column names are allowed.

#### <a name="substituting-values"></a>Substituting values
* __When I try to use the numeric option, it says that my column is not numeric, even though I can see that it is. Why?__
    + If your column of interest only has one or two unique values, it is treated as a non-numeric column. This is because, usually, two or fewer unique numbers in a column indicates that the column is a categorical, rather than a discrete, variable.
    + With only two unique entries, you should be able to substitute values normally by entering the value you would like to substitute.
* __How do I discretize a numeric column?__
    + Start by selecting the column you would like to discretize, and select the "Select a range" option.
    + Select a range of values that you would like to replace, for example, numbers 3 to 4 could change to "three to four".
    + Click the add button to add the range to the table.
    + In the column on the right, input the word or phrase you would like to replace the range with, for example, "three to four".
    + Right click on the table to add another row.
    + Continue choosing ranges and values to replace them with until you have covered the entirety of the column.
    + Click "Substitute" to evaluate the changes.
    + Please note that the ranges are inclusive and that they are evaluated in the order that they appear in the table. This means that if you have overlapping ranges, the numbers in the first range will take precedence.
    
#### <a name="excluding-variables"></a>Excluding variables
* __When I try to use the numeric option, it says that my column is not numeric, even though I can see that it is. Why?__
    + If your column of interest only has one or two unique values, it is treated as a non-numeric column. This is because, usually, two or fewer unique numbers in a column indicates that the column is a categorical, rather than a discrete, variable.
    + With only two unique entries, you should be able to filter the data normally by selecting which value you would like to exclude.
* __One of the options to exclude is `NA`, but I don't see any `NA` values in my data. Where is this coming from?__
    + For the purposes of this application, `NA` values are displayed as blank cells in the table. If there are any blank cells in your data, those are actually `NA` values.

[&uarr; To top](#contents)


### <a name="assay-data"></a>Assay data

* __What is assay data?__
    + This is the actual raw data of the experiment. Depending on the type of experiment, it may be protein or RNA expression levels, or any other kind of metric. The column names are the samples (“GSM”) and the values in the ID column are the metrics we are measuring. This data in conjunction with the clinical data is useful in answering research questions, such as, what kinds of patterns to we see in the RNA expression for cancer patients with stage III prostate cancer vs those with stage I prostate cancer?
* __What is feature data?__
    + This data describes the metrics you see in the ID column of the assay data. Depending on the experiment, these could be probe IDs, gene sequences, etc. Feature data is a kind of thesaurus for the assay ID column; it has an ID column in that matches the one in the assay data and all the other columns are like “synonyms” for those IDs. Sometimes, things like probe IDs might not be very useful, and you might want to look at, say, gene names instead. The feature data is where you get that information.
    
#### <a name="formatting-the-assay-data"></a>Formatting the assay data
* __The spinner where the data should be just keeps spinning. What's wrong?__
    + Sometimes, loading one dataset after another prevents the app from loading the second dataset. Please try reloading the webpage and downloading the data again. If this doesn't fix the problem, please feel free to contact the developers.
* __Why are some of the option buttons disabled?__
    + The "Use different ID column" button is disabled when the data is transposed because the ID becomes the column names, which is harder to substitute. If you would still like to replace the ID column, click "Undo" and "Use different column ID" before transposing.
    + The "Transpose" button is disabled when the entries in the ID column are not all unique. This is because transposing the data makes the ID column the column names, and duplicate column names are not allowed. To enable the "Transpose" button again, click on "Use different column ID" and make sure to use a summarize option other than "keep all". Also make sure to select "Drop NA values" underneath the summarize option.
* __What functionality is not available when my assay data is non-numeric?__
    + You cannot summarize non-numeric data with "Use different column ID". The only option is to keep all the duplicate entries.

[&uarr; To top](#contents)

### <a name="r-scripts"></a>R scripts

* __I ran the script exactly as I downloaded it from the app, but now it's showing error messages. What's going wrong?__
    + Sometimes the script can generate warning messages that look kind of like errors. To see if the entire script ran, check your working directory for the output dataset file. If this file exists, then the warning messages are not important.
    + If the output dataset file was not created by the script, the script might be outdated. At the top of the script, you can find the version of TidyGEO that generated the script. You can then compare this to the version number on the web app under "About". If the versions do not match, you might consider recreating the script by replicating the steps you took to make the first one.

* __Sometimes when I run the R script I downloaded, I get this error:__

```
 Error in load_series(geoID, dataSetIndex) : 
  Error in parseGSEMatrix(destfile, destdir = destdir, AnnotGPL = AnnotGPL, : parsing failed--expected only one '!series_data_table_begin'
```

* __What's wrong?__
    + Sometimes if you've been downloading a lot of datasets from GEO around the same time, GEO starts complaining. Try running the script again or waiting a few minutes and running the script again.

[&uarr; To top](#contents)

### <a name="bugs-and-suggestions"></a>Bugs and suggestions

* If you find an error or would like to make a suggestion, please <a href="https://github.com/srp33/TidyGEO/issues" target="_blank">open an issue on the GitHub page.</a>

[&uarr; To top](#contents)


