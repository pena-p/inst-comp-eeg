## BEHAVIORAL ANALYSES AND PLOTS ####

# Loading ####
# LOAD LIBRARIES
install.packages("afex")
install.packages("gridExtra")

library(tidyverse)
library(dbplyr)
library(stats)
library(afex)
library(reshape2)
library(ggplot2)
library(rstatix)
library(sjPlot)
library(sjmisc)
library(sjlabelled)
library(gridExtra)

# LOAD DATA
data <- read.csv("Z:/results/behavioral/behav_data_preprocessed.csv", sep = ",")

# Filter deleted participants and OUTLIERS
data <- data |> 
  filter(ID != 0) |> 
  filer(OUTLIER != 1)

# T-test regular and catch trials ####

# Performing paired samples t-test acc 

# accuracy main vs catch ####
t.test(data$mean_acc_filt, data$mean_acc_Catch, paired = TRUE)

data_acc_t <- data |> 
  select(ID,mean_acc_filt,mean_acc_Catch)

data_acc_t <- data_acc_t |> 
  melt(id.vars = "ID", variable.name = "Type", value.name = "Accuracy") 

data_acc_t$Type <- ifelse(test = data_acc_t$Type == "mean_acc_filt",
                                no = "Catch",
                                yes = "Regular")

mean_trial_acc <- data_acc_t %>%
  group_by(Type) %>%
  summarise(Mean = mean(Accuracy),
            SD = sd(Accuracy, na.rm = TRUE),
            .groups = 'drop')

print(mean_trial_acc)

p_main_catch_acc <- ggplot(data_acc_t, aes(x = Type, y = Accuracy)) +
  ylim(0.6, 1.02) +
  geom_violin(trim = TRUE, color = "black") +
  geom_jitter(width = 0.07, color = "grey", alpha = 0.6) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult = 1),
               geom="pointrange", color="black") +
  theme_bw() +
  theme_classic() +
  xlab("") +
  ylab("Accuracy") + 
  theme(axis.text.x=element_text(size=23, family = "Helvetica"), axis.text.y=element_text(size=21, family = "Helvetica"),
        axis.title.y = element_text(size = 25, face = "bold", family = "Helvetica"))

plot(p_main_catch_acc)

# Set the directory where you want to save the PDF
output_directory <- "/Users/paulapenazamorano/Documents/experimentos/experiment - INST COMP EEG/paper/FIGURES/behav/" # Replace with your desired folder path

# Create the full file path
output_file <- file.path(output_directory, "main_catch_acc.pdf")

# Save the plot to the specified file path
ggsave(filename = output_file, plot = p_main_catch_acc, device = "pdf", width = 8, height = 6)


# RT main vs catch ####
t.test(data$mean_RT, data$mean_RT_Catch, paired = TRUE)

data_RT_t <- data |> 
  select(ID,mean_RT,mean_RT_Catch)

data_RT_t <- data_RT_t |> 
  melt(id.vars = "ID", variable.name = "Type", value.name = "RT") 


data_RT_t$Type <- ifelse(test = data_RT_t$Type == "mean_RT", 
                          yes = "Regular",
                          no = "Catch")

mean_trial_rt <- data_RT_t %>%
  group_by(Type) %>%
  summarise(Mean = mean(RT),
            SD = sd(RT, na.rm = TRUE),
            .groups = 'drop')


print(mean_trial_rt)
p_main_catch_RT <- ggplot(data_RT_t, aes(x = Type, y = RT)) +
  ylim(0.7, 2) +
  geom_violin(trim = TRUE, color = "black") +
  geom_jitter(width = 0.07, color = "grey", alpha = 0.6) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult = 1),
               geom="pointrange", color="black") +
  theme_bw() +
  theme_classic() +
  xlab("") +
  ylab("Reaction Times (s)") + 
  theme(axis.text.x=element_text(size=23, family = "Helvetica"), axis.text.y=element_text(size=20,family = "Helvetica"), 
        axis.title.y = element_text(size = 25, face = "bold", family = "Helvetica"))

plot(p_main_catch_RT)

# Set the directory where you want to save the PDF
output_directory <- "/Users/paulapenazamorano/Documents/experimentos/experiment - INST COMP EEG/paper/FIGURES/behav/" # Replace with your desired folder path

# Create the full file path
output_file <- file.path(output_directory, "main_catch_rt.pdf")

# Save the plot to the specified file path
ggsave(filename = output_file, plot = p_main_catch_RT, device = "pdf", width = 8, height = 6)


# accuracy subset ####
data_acc <- data |> 
  select(ID,acc_SEL_C_ANIM:acc_INT_S_INAN)

long_data_acc <- data_acc |> 
  melt(id.vars = "ID", variable.name = "Condition", value.name = "Accuracy")
 
#Separate the Condition column into Demand, Category, and Feature
long_data_acc <- long_data_acc |> 
  mutate(Condition = substring(Condition, 5)) |> 
  separate(Condition, into = c("Demand", "Feature", "Category"), sep = "_")

# Repeated-measures ANOVA
aov_result_acc <- aov_car(Accuracy ~ Demand * Category * Feature + Error(ID/(Demand * Category * Feature)), data = long_data_acc)

summary(aov_result_acc)
effectsize::eta_squared(aov_result_acc)

sjPlot::tab_model(aov_result_acc)

# Extract means for each level of Demand, Category, and Feature
means_demand <- long_data_acc %>%
  group_by(Demand) %>%
  summarise(Mean = mean(Accuracy, na.rm = TRUE),
            SD = sd(Accuracy, na.rm = TRUE),
            .groups = 'drop')

means_category <- long_data_acc %>%
  group_by(Category) %>%
  summarise(Mean = mean(Accuracy, na.rm = TRUE),
            SD = sd(Accuracy, na.rm = TRUE),
            .groups = 'drop')

means_feature <- long_data_acc %>%
  group_by(Feature) %>%
  summarise(Mean = mean(Accuracy, na.rm = TRUE),
            SD = sd(Accuracy, na.rm = TRUE),
            .groups = 'drop')


# Add asterisks to significant levels

  means_demand$Significant =  '*'
  means_category$Significant =  '*'
  means_feature$Significant =  '*'
  
  # Create violin plot for Demand
  p_demand_acc <- ggplot(long_data_acc, aes(x = Demand, y = Accuracy)) +
    ylim(0.6, 1.02) +
    geom_violin(trim = TRUE, color = rgb(0.54,0.08,0.18)) +
    geom_jitter(width = 0.07, color = rgb(0.54,0.08,0.18), alpha = 0.2) +
    stat_summary(fun.data=mean_sdl, fun.args = list(mult = 1),
                 geom="pointrange", color="black") +
    geom_text(data = means_demand, aes(label = Significant, x= 1.5, y = 1.01), color = "black", size = 10) +
    theme_bw() +
    theme_classic() +
    xlab("Demand") +
    ylab("Accuracy") + 
    theme(axis.text.x=element_text(size=15, family = "Helvetica"), axis.text.y=element_text(size=18, family = "Helvetica"), 
          axis.title.x = element_text(size = 20, face = "bold", family = "Helvetica"), 
          axis.title.y = element_text(size = 23, face = "bold", family = "Helvetica"))
  
  
  # Create violin plot for Category
  p_category_acc <- ggplot(long_data_acc, aes(x = Category, y = Accuracy)) +
    ylim(0.6, 1.02) +
    geom_violin(trim = TRUE, color =rgb(0.00,0.45,0.74)) +
    geom_jitter(width = 0.07, color =rgb(0.00,0.45,0.74),alpha = 0.2) +
    stat_summary(fun.data=mean_sdl, fun.args = list(mult = 1),
                 geom="pointrange", color="black") +
    geom_text(data = means_category, aes(label = Significant, x= 1.5, y = 1.01), color = "black", size = 10) +
    theme_bw() +
    theme_classic() +
    xlab("Category") +
    ylab("") +
    theme(axis.text.x=element_text(size=18, family = "Helvetica"),axis.title.x = element_text(size = 20,face = "bold", family = "Helvetica"),
          axis.line.y=element_blank(),axis.text.y=element_blank(),
          axis.ticks.y=element_blank(), axis.title.y=element_blank()) 
  
  
  # Create violin plot for Feature
  p_feature_acc <- ggplot(long_data_acc, aes(x = Feature, y = Accuracy)) +
    ylim(0.6, 1.02) +
    geom_violin(trim = TRUE, color = rgb(0.47,0.67,0.19)) +
    geom_jitter(width = 0.07, color = rgb(0.47,0.67,0.19),alpha = 0.2) +
    stat_summary(fun.data=mean_sdl, fun.args = list(mult = 1), 
                 geom="pointrange", color="black") +
    geom_text(data = means_feature, aes(label = Significant,  x= 1.5, y = 1.01), color = "black", size = 10) +
    theme_bw() +
    theme_classic() +
    xlab("Feature") +
    ylab("") +
    theme(axis.text.x=element_text(size=18, family = "Helvetica"),axis.title.x = element_text(size = 20,face = "bold", family = "Helvetica"),
          axis.line.y=element_blank(),axis.text.y=element_blank(),
          axis.ticks.y=element_blank(), axis.title.y=element_blank())
  
  
  # Combine plots into one figure
  p_acc_anova <- grid.arrange(p_demand_acc, p_category_acc, p_feature_acc, ncol = 3)

  # Set the directory where you want to save the PDF
  output_directory <- "/Users/paulapenazamorano/Documents/experimentos/experiment - INST COMP EEG/paper/FIGURES/behav/" # Replace with your desired folder path
  
  # Create the full file path
  output_file <- file.path(output_directory, "anova_acc.pdf")
  
  # Save the plot to the specified file path
  ggsave(filename = output_file, plot = p_acc_anova, device = "pdf", width = 9, height = 6)
  
  
# RT subset ####
data_rt <- data |> 
  select(ID,rt_SEL_C_ANIM:rt_INT_S_INAN)

long_data_rt <- data_rt |> 
  melt(id.vars = "ID", variable.name = "Condition", value.name = "RT")

#Separate the Condition column into Demand, Category, and Feature
long_data_rt <- long_data_rt |> 
  mutate(Condition = substring(Condition, 4)) |> 
  separate(Condition, into = c("Demand","Feature", "Category"), sep = "_")

# Repeated-measures ANOVA
aov_result_rt <- aov_car(RT ~ Demand * Category * Feature + Error(ID/(Demand * Category * Feature)), data = long_data_rt)

summary(aov_result_rt)
effectsize::eta_squared(aov_result_rt)

sjPlot::tab_model(aov_result_rt)

# post-hoc test for significant interaction demand:feature
pwc <- long_data_rt |> 
  group_by(Category) |> 
  pairwise_t_test(
  formula = RT ~ Demand,
  paired = TRUE,
  p.adjust.method = "holm") |> 
  ungroup()

print(pwc)

# Extract means for each level of Demand, Category, and Feature
means_demand <- long_data_rt %>%
  group_by(Demand) %>%
  summarise(Mean = mean(RT),
            SD = sd(RT, na.rm = TRUE),
            .groups = 'drop')


means_category <- long_data_rt %>%
  group_by(Category) %>%
  summarise(Mean = mean(RT),
            SD = sd(RT, na.rm = TRUE),
            .groups = 'drop')

means_feature <- long_data_rt %>%
  group_by(Feature) %>%
  summarise(Mean = mean(RT),
            SD = sd(RT, na.rm = TRUE),
            .groups = 'drop')

# Add asterisks to significant levels

means_demand$Significant =  '*'
means_category$Significant =  '*'
means_feature$Significant =  '*'


# Create violin plot for Demand
p_demand_rt <- ggplot(long_data_rt, aes(x = Demand, y = RT)) +
  geom_violin(trim = TRUE, color = rgb(0.54,0.08,0.18)) +
  scale_fill_manual(values=rgb(0.54,0.08,0.18))+
  ylim(0.5, 2.1) +
  geom_jitter(width = 0.07, color = rgb(0.54,0.08,0.18), alpha = 0.2) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult = 1),
               geom="pointrange", color="black") +
  geom_text(data = means_demand, aes(label = Significant, x= 1.5, y = 2.07), color = "black", size = 10) +
  theme_bw() +
  theme_classic() +
  xlab("Demand") +
  ylab("Reaction Times (s)") + 
  theme(axis.text.x=element_text(size=15), axis.text.y=element_text(size=18), axis.title.x = element_text(size = 20, face = "bold"), 
        axis.title.y = element_text(size = 23, face = "bold"))


# Create violin plot for Category
p_category_rt <- ggplot(long_data_rt, aes(x = Category, y = RT)) +
  geom_violin(trim = TRUE, color =rgb(0.00,0.45,0.74)) +
  ylim(0.5, 2.1) +
  geom_jitter(width = 0.07, color =rgb(0.00,0.45,0.74),alpha = 0.2) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult = 1),
               geom="pointrange", color="black") +
  geom_text(data = means_category, aes(label = Significant, x= 1.5, y = 2.07), color = "black", size = 10) +
  theme_bw() +
  theme_classic() +
  xlab("Category") +
  ylab("") +
  theme(axis.text.x=element_text(size=18),axis.title.x = element_text(size = 20,face = "bold"),
        axis.line.y=element_blank(),axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), axis.title.y=element_blank())


# Create violin plot for Feature
p_feature_rt <- ggplot(long_data_rt, aes(x = Feature, y = RT)) +
  geom_violin(trim = TRUE, color = rgb(0.47,0.67,0.19)) +
  ylim(0.5, 2.1) +
  geom_jitter(width = 0.07, color = rgb(0.47,0.67,0.19),alpha = 0.2) +
  stat_summary(fun.data=mean_sdl, fun.args = list(mult = 1), 
                   geom="pointrange", color="black") +
  geom_text(data = means_feature, aes(label = Significant,  x= 1.5, y = 2.07), color = "black", size = 10) +
  theme_bw() +
  theme_classic() +
  xlab("Feature") +
  ylab("") +
  theme(axis.text.x=element_text(size=18),axis.title.x = element_text(size = 20,face = "bold"),
        axis.line.y=element_blank(),axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), axis.title.y=element_blank())


# Combine plots into one figure
p_rt_anova <- grid.arrange(p_demand_rt, p_category_rt, p_feature_rt, ncol = 3)


# Set the directory where you want to save the PDF
output_directory <- "/Users/paulapenazamorano/Documents/experimentos/experiment - INST COMP EEG/paper/FIGURES/behav/" # Replace with your desired folder path

# Create the full file path
output_file <- file.path(output_directory, "anova_rt.pdf")

# Save the plot to the specified file path
ggsave(filename = output_file, plot = p_rt_anova, device = "pdf", width = 9, height = 6)

