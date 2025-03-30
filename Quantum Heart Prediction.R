# Load required libraries
library(tidyverse)
library(caret)

# Read the CSV file
data <- read.csv("Heart-Prediction-Quantum-Dataset.csv")

# Display the first few rows of the data
head(data)

# Check the structure of the data
str(data)

# Check for missing values
sum(is.na(data))

# Convert Gender and HeartDisease to factor variables
data$Gender <- as.factor(data$Gender)
data$HeartDisease <- as.factor(data$HeartDisease)

# Summary of the data
summary(data)

# Check for outliers in numerical variables
boxplot(data$Age, main="Age")
boxplot(data$BloodPressure, main="BloodPressure")
boxplot(data$Cholesterol, main="Cholesterol")
boxplot(data$HeartRate, main="HeartRate")
boxplot(data$QuantumPatternFeature, main="QuantumPatternFeature")

# Remove outliers in Cholesterol (example)
Q1 <- quantile(data$Cholesterol, 0.25)
Q3 <- quantile(data$Cholesterol, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

data <- data[data$Cholesterol >= lower_bound & data$Cholesterol <= upper_bound, ]

# Scale numerical features
numerical_features <- c("Age", "BloodPressure", "Cholesterol", "HeartRate", "QuantumPatternFeature")
data[numerical_features] <- scale(data[numerical_features])

# Display the processed data
head(data)

# Histograms
hist(data$Age, main="Age Distribution", xlab="Age", col="skyblue")
hist(data$BloodPressure, main="Blood Pressure Distribution", xlab="Blood Pressure", col="lightgreen")
hist(data$Cholesterol, main="Cholesterol Distribution", xlab="Cholesterol", col="lightcoral")
hist(data$HeartRate, main="Heart Rate Distribution", xlab="Heart Rate", col="lightgoldenrod")
hist(data$QuantumPatternFeature, main="Quantum Pattern Feature Distribution", xlab="Quantum Pattern Feature", col="lavender")


# Bar plots
plot(data$Gender, main="Gender Distribution", ylab="Frequency", col=c("pink", "lightblue"))
plot(data$HeartDisease, main="Heart Disease Distribution", ylab="Frequency", col=c("lightgreen", "salmon"))

# Scatter plots
plot(data$Age, data$HeartDisease, main="Age vs Heart Disease", xlab="Age", ylab="Heart Disease", col=ifelse(data$HeartDisease == 1, "red", "blue"))
plot(data$BloodPressure, data$HeartDisease, main="Blood Pressure vs Heart Disease", xlab="Blood Pressure", ylab="Heart Disease", col=ifelse(data$HeartDisease == 1, "red", "blue"))
plot(data$Cholesterol, data$HeartDisease, main="Cholesterol vs Heart Disease", xlab="Cholesterol", ylab="Heart Disease", col=ifelse(data$HeartDisease == 1, "red", "blue"))
plot(data$HeartRate, data$HeartDisease, main="Heart Rate vs Heart Disease", xlab="Heart Rate", ylab="Heart Disease", col=ifelse(data$HeartDisease == 1, "red", "blue"))
plot(data$QuantumPatternFeature, data$HeartDisease, main="Quantum Pattern Feature vs Heart Disease", xlab="Quantum Pattern Feature", ylab="Heart Disease", col=ifelse(data$HeartDisease == 1, "red", "blue"))

# Correlation matrix
correlation_matrix <- cor(data[,numerical_features])
print(correlation_matrix)

# Install and load corrplot package
install.packages("corrplot")
library(corrplot)

# Create a colorful correlation matrix
corrplot(correlation_matrix, method="color", type="upper", order="hclust", tl.col="black", tl.srt=45)

install.packages("caret")
library(caret)
4. #build models by  first splitting the data into training and testing sets
set.seed(123)
train_index <- createDataPartition(data$HeartDisease, p = 0.7, list = FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]

# Train the logistic regression model
model <- glm(HeartDisease ~ ., data = train_data, family = "binomial")

# Summarize the model
summary(model)

# Make predictions on the test data
predictions <- predict(model, newdata = test_data, type = "response")
predicted_classes <- ifelse(predictions > 0.5, 1, 0)

# Evaluate the model
confusionMatrix(as.factor(predicted_classes), test_data$HeartDisease)

