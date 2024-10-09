# data cleaning for the redraw heatmap analysis 

library(tidyverse) # Easily Install and Load the 'Tidyverse'
library(memoryR) # Functions for the analysis used for the MA thesis/paper: Memeory polarization over visual evidence of climate change""
library(grid) # The Grid Graphics Package
library(jpeg) # Read and write JPEG images
library(RColorBrewer) # ColorBrewer Palettes
# run this to disable scientific notation
options(scipen = 999)

# read in the redraw data FOR THE CLIMATE CONDITION ONLY
redraw <- read_csv("data/climate_data/bubble_climate.csv",
                   col_names = FALSE,
                   skip = 1)

# use the memory r function to clean the neutral petition data set
mturk_path <- "data/climate_data/mturk_climate.csv"
analysis_path <- "data/climate_data/petition_climate.csv"
attention_question <- "This is an attention check. Please select ‘strongly agree’ to pass this check. You will not be compensated if you fail this check."

petition <- clean_analysis(path1 = mturk_path, path2 = analysis_path, question = attention_question)

# clean the bubbleview data set via removing participants and columns 
discard_df <- unique(petition$MTurk)

redraw <- redraw |> 
  filter(X3 %in% discard_df) |> 
  rename(subject = X1,
         MTurk = X3) |> 
  select(- c(X2, X4, X5, X6, X7, X8))


# add the political orientation column the the bubble view data set 
mturk_poli_data <- petition |> 
  group_by(MTurk) |> 
  summarise(poli = Politic)

mturk_poli_data <- mturk_poli_data |> 
  unique(by = "MTurk") |> 
  mutate(MTurk = as.character(MTurk))

redraw <- left_join(redraw, mturk_poli_data, by = "MTurk")

redraw <- redraw |> 
  relocate(poli)

# turn the data into something that is tidy 
data_only <- redraw |> 
  select(-c(poli, subject, MTurk))

subject_only <- redraw |> 
  select(poli, subject, MTurk)

data_num <- purrr::map_df(data_only, as.numeric)

for (i in seq_along(data_num)) {
  if (i %in% seq(1, nrow(data_num), by = 3)) {
    names(data_num)[i] <- "x"
  } else if (i %in% seq(2, ncol(data_num), by = 3)) {
    names(data_num)[i] <- "y"
  } else {
    names(data_num)[i] <- "time"
  }
}

# drop the last 3 cloumns cuz it does not have time data 
# remember to add this to the final analysis 
data_num <- data_num[-c(520, 521, 522)]

all_data <- cbind(subject_only, data_num)

# finally, make the data tidy 
longer <- all_data |> 
  pivot_longer(!c("subject", "poli", "MTurk"), names_to = "axis", values_to = "value")

tidy_bubble_data <- longer |> 
  pivot_wider(names_from = axis, values_from = value) |> 
  unchop(everything())

# new map data
bubble_data <- tidy_bubble_data |> 
  group_by(poli, x, subject) |> 
  summarise(y_mean = mean(y, na.rm = TRUE),
            time_mean = mean(time, na.rm = TRUE))

# make the map plots 

# preamble
img <- readJPEG("img/full.jpg")
Xmin <- 0
Xmax <- 837
Ymin <- 0
Ymax <- 420

tidy_bubble_data  |> 
  #filter(poli == "Democrat") |> 
  #filter(poli == "Republican") |>
  filter(poli != "Independent") |>
  ggplot(aes(x = x, y = y)) +
  annotation_custom(rasterGrob(img,
                               width = unit(1, "npc"),
                               height = unit(1, "npc")),
                    Xmin, Xmax, -Ymax, Ymin) +
  #geom_point() +
  stat_density_2d(aes(x = x, y = y, fill = ..level.., alpha = ..level..), size = 10, bins = 20, geom = 'polygon') +
  scale_fill_gradient(low = "green", high = "red") +
  scale_alpha_continuous(range=c(0.11, 0.99) , guide = "none") +
  scale_y_reverse() +
  expand_limits(y = c(Ymin, Ymax)) +
  theme_void() +
  theme(legend.position = "none") +
  facet_wrap(~poli)


bubble_data  |> 
  #filter(poli == "Democrat") |> 
  filter(poli == "Republican") |>
  #filter(poli != "Independent") |>
  ggplot(aes(x = x, y = y_mean)) +
  annotation_custom(rasterGrob(img,
                               width = unit(1, "npc"),
                               height = unit(1, "npc")),
                    Xmin, Xmax, -Ymax, Ymin) +
  #geom_point() +
  stat_density_2d(aes(x = x, y = y_mean, fill = ..level.., alpha = ..level..), size = 10, bins = 20, geom = 'polygon') +
  scale_fill_gradient(low = "green", high = "red") +
  scale_alpha_continuous(range=c(0.11, 0.99) , guide = "none") +
  scale_y_reverse() +
  expand_limits(y = c(Ymin, Ymax)) +
  theme_void() +
  theme(legend.position = "none")
# save the data from the bubble_data data set \
ggsave(here::here("plots_for_paper", "dem_cli_cond.png"), dpi = 800, width = 9, height = 5)
ggsave(here::here("plots_for_paper", "rep_cli_cond.png"), dpi = 800, width = 9, height = 5)



bubble_data  |> 
  #filter(poli == "Democrat") |> 
  filter(poli == "Republican") |>
  ggplot(aes(x = x, y = y_mean)) +
  annotation_custom(rasterGrob(img,
                               width = unit(1, "npc"),
                               height = unit(1, "npc")),
                    Xmin, Xmax, -Ymax, Ymin) +
  geom_point() +
  stat_density_2d(aes(x = x, y = y_mean, fill = ..level.., alpha = ..level..), size = 10, bins = 20, geom = 'polygon') +
  scale_fill_gradient(low = "green", high = "red") +
  scale_alpha_continuous(range=c(0.11, 0.99) , guide = "none") +
  scale_y_reverse() +
  expand_limits(y = c(Ymin, Ymax)) +
  theme_void() +
  theme(legend.position = "none")
