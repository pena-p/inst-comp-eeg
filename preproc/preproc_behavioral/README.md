# BEHAVIORAL PREPROCESSING
This scripts preprocessed the behavioral data for the Behavioral Analysis (repeated measures ANOVA).

The resulting table in csv will be saved on your computer, every row is a participant and every column a condition's mean.

**Notes:** 
 - Use Matlab to execute the script.
 - Add the folder with the behavioral data to the path.

### Steps:
 - Filter behavioral and RT data
 - Compute conditon-wise means both for paired-sample t tests and repeated     measures ANOVA.
 - Compute additional measures.
 - Detect outliers: (1) more than 2 standard deviations above or below the     sample mean in overall accuracy, and (2) below chance performance in        catch trials



