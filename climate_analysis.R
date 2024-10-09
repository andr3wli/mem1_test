# data cleaning for the petition climate (experiment 1)

library(memoryR) # Functions for the analysis used for the MA thesis/paper: Memeory polarization over visual evidence of climate change""
library(tidyverse) # Easily Install and Load the 'Tidyverse' 

# 1 cleaning for petition
mturk_path <- "data/climate_data/mturk_climate.csv"
analysis_path <- "data/climate_data/petition_climate.csv"
attention_question <- "This is an attention check. Please select ‘strongly agree’ to pass this check. You will not be compensated if you fail this check."

petition <- clean_analysis(path1 = mturk_path, path2 = analysis_path, question = attention_question)

# 2 data cleaning for the redraw data
draw_path <- "data/climate_data/redraw_climate.csv"
redraw <- redraw_clean_data(draw_path, discard_data = petition$MTurk) |> 
  mutate(MTurk = as.numeric(MTurk))

# 3 add political orientation to the redraw data set
redraw_with_poli <- add_politics_col(analysis_data = petition, redraw_data = redraw)

# 4 tidy up the data set
foo <- tidy_redraw_data(data = redraw_with_poli)

# 5 clean the tidy data 
clean_data <- make_clean_redraw(foo)


###########################################################################

                   # create the plots 
img <- "img/full.jpg"

# preamble for plot
clean_plot_data <- clean_for_plot(clean_data)

                   # create the whole plot
whole_plot(img_path = img, df = clean_plot_data, line = FALSE)

# half plot 
half_plot(img_path = img, df = clean_plot_data, type = "rise")
half_plot(img_path = img, df = clean_plot_data, type = "flat")


subject_clean <- clean_data |> 
  group_by(poli, x, subject) |> 
  summarise(y_mean = mean(y, na.rm = T))
  

(i <- subject_clean |> 
  filter(poli == "Independent") |> 
  #filter(poli != "Independent") |> 
  ggplot(aes(x = x, y = y_mean)) +
  #geom_point() +
  geom_line(aes(group = poli)) +
  #geom_smooth(aes(group = poli)) +
  scale_y_reverse() +
  scale_color_manual(values = "red") +
  #scale_color_manual(values = c("blue", "grey", "red")) +
  theme_classic() +
  facet_wrap(~subject))


# statistical analysis
stats_df <- add_salient_col(df = clean_data)

flat <- flat_data(df = stats_df)
rise <- rise_data(df = stats_df)

full <- rbind(flat, rise)


# anova 
aov_full <- aov(mean_slope ~ salient * poli + Error(subject/salient * poli), data = full)
summary(aov_full)

# flat aov
flat_aov <- aov(mean_y ~ poli, data = filter(full, salient == "Flat"))
summary(flat_aov)

# rise aov
rise_aov <- aov(mean_int ~ poli, data = filter(full, salient == "Rising"))
summary(rise_aov)


