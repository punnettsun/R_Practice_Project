# Packages & libraries
install.packages("ggplot2")
install.packages("tidyverse")

library(ggplot2)
library(tidyverse)
library(stringr)

# Change working directory 
setwd("/Users/punitsundar/Documents/Summer_2020/R_Practice/R_Practice_Project")
data <- read.csv("covid19data.csv", header = TRUE,sep = ",")

# Removes all rows that have any number of NA's in them
na_data <- na.omit(data)  

# Removes rows that have "Unassigned" county name
tidy_data <- na_data[!(na_data$County.Name=="Unassigned"),]
tidy_data <- droplevels(tidy_data)

county_names <- levels(tidy_data$County.Name)
print(county_names)

# Check if any row has "Unassigned"
#for(row in tidy_data[,1]) {
#    if(row == "Unassigned") {
#        print("PRESENT")
#    }
#}


# Function to create time series plot for Most Recent Date & Death Count Plot
plot_time_series_confirmed <- function(name) {
        county <- tidy_data[(tidy_data$County.Name==name),]
        county$Most.Recent.Date <- as.Date(county$Most.Recent.Date,'%m/%d/%Y')
        ggplot(data = county, aes(Most.Recent.Date, Total.Count.Deaths)) +
                geom_line()
}


# List of county names
c_names <- unique(tidy_data$County.Name)
print(c_names)

# Saves each plot pdf in folder (58 total)
for(county in c_names) {
        county_name <- str_replace_all(county,fixed(" "),"")
        pdf_name <- paste(county,".pdf",sep='')
        my_plot <- plot_time_series_confirmed(county)
        ggsave(filename = pdf_name, plot = my_plot, 
               device = "pdf", path = "Plot_Pictures/",
               width = 5, height = 5)
}
