library(tidyverse) # Easily Install and Load the 'Tidyverse'
library(grid) # The Grid Graphics Package
library(jpeg) # Read and write JPEG images
library(ggtext) # Improved Text Rendering Support for 'ggplot2'
library(patchwork) # The Composer of Plots

# read in the image 
img <- readJPEG("img/full.jpg")
draw_img <- readJPEG("img/graph.jpg")

Xmin <- 0
Xmax <- 837
Ymin <- 0
Ymax <- 420

# plot the image in ggplot 
# this creates the stimuli figure needed for the paper 
tidy_bubble_data  |> 
  filter(poli == "Republican") |>
  ggplot(aes(x = x, y = y)) +
  annotation_raster(img, -Inf, Inf, -Inf, Inf, interpolate = TRUE) +
  labs(x = "", y = "", color = "",
       title = "<strong> The graph below shows the <span style='color:#1b9e77'>average global temperature change</span> <br>(<span style='color:#d95f02'>some value change</span>) from 1880 to 2020:</strong>") +
  theme(plot.title = element_markdown(hjust=0.5))
# save plot 
ggsave(here::here("plots_for_paper", "stim_exp1.png"), dpi = 800, width = 9, height = 5)

# create the plot for the draw task 
tidy_bubble_data  |> 
  filter(poli == "Republican") |>
  ggplot(aes(x = x, y = y)) +
  annotation_raster(draw_img, -Inf, Inf, -Inf, Inf, interpolate = TRUE) +
  annotate("text", x = 4, y = 25, label = "+", size = 9) +
  labs(x = "", y = "", color = "",
       title = "<strong>Your task is to draw the <span style='color:#1b9e77'>temperature curve</span> (<span style='color:#d95f02'>curve</span>) and reproduce<br> the graph from 1880 to 2020 as accurately as possible.</strong>") +
  theme_void() +
  theme(plot.title = element_markdown(hjust=0.5)) 
# save the plot 
ggsave(here::here("plots_for_paper", "draw_task.png"), dpi = 800, width = 9, height = 5)

# this creates the bubblview technique figure for the paper 
# can use the full plot img from above 
time <- readJPEG("img/time.jpg")

bbv <- tidy_bubble_data  |> 
  filter(poli == "Republican") |>
  ggplot(aes(x = x, y = y)) +
  annotation_raster(img, -Inf, Inf, -Inf, Inf, interpolate = TRUE) +
  labs(x = "", y = "")


time_plot <- tidy_bubble_data  |> 
  filter(poli == "Republican") |>
  ggplot(aes(x = x, y = y)) +
  annotation_raster(time, -Inf, Inf, -Inf, Inf, interpolate = TRUE) +
  labs(x = "", y = "")

# combine the two 
combine_plot <- bbv + time_plot

# add title to the combined plot 
combine_plot + plot_annotation(
  title = "<strong>BubbleView Technique</strong>",
  theme = theme(plot.title = element_markdown(size = 17))
)

# save the combined plot 
ggsave(here::here("plots_for_paper", "bubble_view.png"), dpi = 800, width = 15, height = 5)

