gettingAndCleaningData
======================

The only script one needs to run in order to reproduce the data set is run_analysis.R. The resulting data set is called finalDatafile.txt. 

The script makes the file making use of the following steps:
  1. Read the labels and feature names
  2. Read the test data
  3. The test activity numbers are replaced by the activity name for readability
  4. The test data set is composed by combining the subjects, activities and testdata
  5. A subset of this test data set containing the mean's and std's is saved
  6. Step 2-5 are repeated, but now for the train data
  7. An extra column is added to both data sets which states whether it is training or test data
  8. Now the datasets are merged. This is done using the 'rbind' function
  9. The large datasets used to get to this point are removed here to clear memory
  10. In order to create a tidy data set containing the averages results per subject per activity
      the data needs to be split up into these factors. Therefore these factor are defined
  11. The 2 factors are combined using 'interaction' creating 180 differenct factor levels
  12. I used a column by column approach to set up the final data set, starting with the first column
  13. After the first column, the next columns are added one by one in a small for loop
  14. The names that correspond to the columns are taken on those of the orignal dataset
  15. Some columns are not present anymore since we now work with the factorlevels instead so
      these column names are removed
  16. Finally the new dataset is written to 'finalDatafile.txt' using a tab as seperator
