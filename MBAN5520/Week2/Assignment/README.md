# MBAN5520 Regression Analysis Assignment

## Overview

This assignment applies regression analysis concepts to predict house prices using the Ames Housing dataset. It covers data preprocessing, exploratory analysis, model building, interpretation, and prediction.

## Files

- `regression_assignment.qmd` - Main assignment file (Quarto document)
- `../AmesHousing.csv` - Dataset (located in parent directory)

## Requirements

### R Packages

Install the following packages before running the assignment:

```r
install.packages(c(
  "tidyverse",
  "knitr",
  "kableExtra",
  "ggplot2",
  "corrplot",
  "GGally",
  "broom",
  "car",
  "patchwork"
))
```

## Running the Assignment

### Option 1: RStudio
1. Open `regression_assignment.qmd` in RStudio
2. Click the "Render" button
3. The HTML output will be generated automatically

### Option 2: Command Line
```bash
quarto render regression_assignment.qmd
```

## Assignment Structure

### Section 1: Data Loading and Preprocessing
- Load and inspect the Ames Housing dataset
- Handle missing values
- Select relevant variables

### Section 2: Exploratory Data Analysis
- Summary statistics
- Distribution analysis
- Correlation analysis
- Scatter plots and visualizations

### Section 3: Building the Regression Model
- Model specification
- Multiple linear regression estimation

### Section 4: Model Estimation and Interpretation
- Coefficient interpretation
- Practical examples

### Section 5: Which Factors Affect Price Most?
- Standardized coefficients
- Variable importance

### Section 6: Statistical Significance and Confidence Intervals
- Confidence intervals for coefficients
- Hypothesis testing
- Significance levels

### Section 7: Model Quality Metrics
- R² and Adjusted R²
- F-statistic
- Residual diagnostics

### Section 8: Prediction with Train-Test Split
- 75-25 data split
- Model training
- Prediction on test set
- Performance metrics (RMSE, MAE, MAPE)

### Section 9: Prediction Intervals and Uncertainty
- Understanding prediction intervals
- Coverage rate analysis
- Visualization

### Section 10: Summary and Conclusions
- Key findings
- Connection to BLUE theory
- Reflection questions

## Questions to Answer

Throughout the assignment, there are **25+ questions** that students must answer, covering:

- Data preprocessing decisions
- Exploratory data analysis insights
- Coefficient interpretation
- Statistical significance
- Model quality assessment
- Prediction accuracy evaluation
- Theoretical connections to BLUE properties

## Learning Objectives

By completing this assignment, students will:

1. Apply data preprocessing techniques
2. Conduct thorough exploratory data analysis
3. Build and interpret multiple linear regression models
4. Understand and calculate standardized coefficients
5. Use confidence intervals for inference
6. Assess model quality using R², F-statistic, and residual diagnostics
7. Make predictions and evaluate prediction accuracy
8. Quantify uncertainty using prediction intervals
9. Connect practical regression analysis to theoretical BLUE concepts

## Tips for Success

1. **Read carefully**: Each section builds on the previous one
2. **Run code sequentially**: Don't skip code chunks
3. **Answer all questions**: Use complete sentences and show calculations
4. **Interpret, don't just calculate**: Explain what the numbers mean
5. **Connect theory to practice**: Reference BLUE properties from course material
6. **Check your work**: Verify that predictions and intervals make sense

## Submission Requirements

- [ ] Rendered HTML file with all code and output
- [ ] All questions answered with complete explanations
- [ ] Visualizations included and interpreted
- [ ] Code runs without errors
- [ ] Theoretical concepts connected to practical analysis

## Grading Criteria

- Data preprocessing and exploration (20%)
- Model building and interpretation (25%)
- Statistical significance and confidence intervals (20%)
- Prediction accuracy and intervals (20%)
- Connection to theoretical concepts (15%)

## Support

If you encounter issues:
1. Check that all required packages are installed
2. Verify the dataset path is correct (`../AmesHousing.csv`)
3. Ensure you're running R version 4.0 or higher
4. Review the course material on inferential statistics and BLUE

---

**Good luck with your regression analysis!**
