library(tidyverse)
library(memoryR)

# petiton data 
petition_climate <- read_csv("data/petition.csv") |> 
  filter(Condition == "climate")
write_csv(petition_climate, file = here::here("data", "climate_data", "petition_climate.csv"))

petition_neutral <- read_csv("data/petition.csv") |> 
  filter(Condition == "neutral")
write_csv(petition_neutral, file = here::here("data", "neutral_data", "petition_neutral.csv"))

# mturk data 
mturk_climate <- read_csv("data/mturkcode.csv") |> 
  filter(Condition == "climate")
write_csv(mturk_climate, file = here::here("data", "climate_data", "mturk_climate.csv"))

mturk_neutral <- read_csv("data/mturkcode.csv") |> 
  filter(Condition == "neutral")
write_csv(mturk_neutral, file = here::here("data", "neutral_data", "mturk_neutral.csv"))


# redraw data 
redraw_climate <- read_csv("data/draw_xyt.csv") |> 
  filter(Condition == "climate")
write_csv(redraw_climate, file = here::here("data", "climate_data", "redraw_climate.csv"))

redraw_neutral <- read_csv("data/draw_xyt.csv") |> 
  filter(Condition == "neutral")
write_csv(redraw_neutral, file = here::here("data", "neutral_data", "redraw_neutral.csv"))


# bubble view data 
bubble_climate <- read_csv("data/bubble_xyt.csv") |> 
  filter(Condition == "climate")
write_csv(bubble_climate, file = here::here("data", "climate_data", "bubble_climate.csv"))

bubble_neutral <- read_csv("data/bubble_xyt.csv") |> 
  filter(Condition == "neutral")
write_csv(bubble_neutral, file = here::here("data", "neutral_data", "bubble_neutral.csv"))


