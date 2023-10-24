
# install packages and loading

library(data.table)
library(haven)
library(dplyr)
library(readxl)
library(stringr)

setwd("C:/Users/HashJam/OneDrive/바탕 화면/Studies/Projects/NIPA_infection")

sido_code_data <-
  read_xlsx("influenza_nationwide_221231.xlsx", sheet = "시도코드") %>%
  rename(c("sido" = "시도코드", "sido_name" = "시도명"))

data_influ_sheet1 <- 
  read_xlsx("influenza_nationwide_221231.xlsx", sheet = "외래입원주부상병") %>%
  mutate(severity = 1)

data_influ_sheet2 <- 
  read_xlsx("influenza_nationwide_221231.xlsx", sheet = "입원주부상병") %>%
  mutate(severity = 2)

data_influ <-
  data_influ_sheet1 %>%
  bind_rows(data_influ_sheet2)

data_influ <-
  data_influ %>%
  rename(c("date" = "FST_DT", "sido" = "SIDO", "gen" = "GEN", "agg" = "AGG", "cnt" = "CNT")) %>%
  select(sido, date, gen, agg, severity, cnt) %>%
  arrange(sido, date, gen, agg, severity) %>%
  mutate(date = as.Date(as.character(date), "%Y%m%d")) %>% 
  data.table()

case_data <-
  data_influ[, .(sido = rep(sido, cnt),
                date = rep(date, cnt),
                gen = rep(gen, cnt),
                agg = rep(agg, cnt),
                severity = rep(severity, cnt))]

case_data <-
  case_data %>%
  mutate(influ = 1,
         id = row_number())

control_data_1 <-
  data_influ[, .(sido = rep(sido, cnt),
                 date = rep(date, cnt),
                 gen = rep(gen, cnt),
                 agg = rep(agg, cnt))] %>%
  mutate(date = date - 14)

control_data_1 <-
  control_data_1 %>%
  mutate(influ = 0,
         id = row_number())

control_data_2 <-
  data_influ[, .(sido = rep(sido, cnt),
                 date = rep(date, cnt),
                 gen = rep(gen, cnt),
                 agg = rep(agg, cnt))] %>%
  mutate(date = date - 7)

control_data_2 <-
  control_data_2 %>%
  mutate(influ = 0,
         id = row_number())

control_data_3 <-
  data_influ[, .(sido = rep(sido, cnt),
                 date = rep(date, cnt),
                 gen = rep(gen, cnt),
                 agg = rep(agg, cnt))] %>%
  mutate(date = date + 7)

control_data_3 <-
  control_data_3 %>%
  mutate(influ = 0,
         id = row_number())

control_data_4 <-
  data_influ[, .(sido = rep(sido, cnt),
                 date = rep(date, cnt),
                 gen = rep(gen, cnt),
                 agg = rep(agg, cnt))] %>%
  mutate(date = date + 14)

control_data_4 <-
  control_data_4 %>%
  mutate(influ = 0,
         id = row_number())


setwd("C:/Users/HashJam/OneDrive/바탕 화면/Studies/Projects/NIPA_infection/20230907_매개변수_전처리완료데이터")

parameter_data <- data.frame()

num <- 0

for (file_name in list.files(pattern = ".csv")) {
  
  num <- num + 1
  
  sido_row <- sido_code_data %>% filter(sido_name == file_name %>% str_sub(1, -5))
  sido_code <- sido_row$sido
  
  data_influ_sido <- data_influ %>% filter(sido == sido_code) %>% data.table()
  
  data_source <- 
    fread(file_name, select = c(1, 3, 4, 5, 8, 9)) %>% 
    mutate(date = as.Date(date), sido = sido_code) 
    
  if (num == 1) {
    parameter_data <- data_source
  } else {
    parameter_data <-
      bind_rows(parameter_data, data_source)
  }
  
}

# case_data_lag <-
#   case_data %>%
#   left_join(parameter_data, by = c("sido", "date")) %>%
#   select(id, sido, gen, agg, severity, influ, date,
#          avg_humidity, avg_rainfall, avg_sun_hours,
#          avg_temperature, avg_wind_velocity) %>%
#   rename(lag0_humidity = avg_humidity,
#          lag0_rainfall = avg_rainfall,
#          lag0_sun_hours = avg_sun_hours,
#          lag0_temperature = avg_temperature,
#          lag0_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 1) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag1_humidity = avg_humidity,
#          lag1_rainfall = avg_rainfall,
#          lag1_sun_hours = avg_sun_hours,
#          lag1_temperature = avg_temperature,
#          lag1_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 2) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag2_humidity = avg_humidity,
#          lag2_rainfall = avg_rainfall,
#          lag2_sun_hours = avg_sun_hours,
#          lag2_temperature = avg_temperature,
#          lag2_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 3) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag3_humidity = avg_humidity,
#          lag3_rainfall = avg_rainfall,
#          lag3_sun_hours = avg_sun_hours,
#          lag3_temperature = avg_temperature,
#          lag3_wind_velocity = avg_wind_velocity) %>%
#   select(-join_date) %>%
#   mutate(lag0_3_humidity =
#            mean(c(lag0_humidity, lag1_humidity,
#                   lag2_humidity, lag3_humidity), na.rm = TRUE),
#          lag0_3_rainfall =
#            mean(c(lag0_rainfall, lag1_rainfall,
#                   lag2_rainfall, lag3_rainfall), na.rm = TRUE),
#          lag0_3_sun_hours =
#            mean(c(lag0_sun_hours, lag1_sun_hours,
#                   lag2_sun_hours, lag3_sun_hours), na.rm = TRUE),
#          lag0_3_temperature =
#            mean(c(lag0_temperature, lag1_temperature, 
#                   lag2_temperature, lag3_temperature), na.rm = TRUE),
#          lag0_3_wind_velocity =
#            mean(c(lag0_wind_velocity, lag1_wind_velocity, 
#                   lag2_wind_velocity, lag3_wind_velocity), na.rm = TRUE)) %>%
#   rename(lag0_date = date)
# 
# control_data_1_lag <-
#   control_data_1 %>%
#   left_join(parameter_data, by = c("sido", "date")) %>%
#   select(id, sido, gen, agg, influ, date,
#          avg_humidity, avg_rainfall, avg_sun_hours,
#          avg_temperature, avg_wind_velocity) %>%
#   rename(lag0_humidity = avg_humidity,
#          lag0_rainfall = avg_rainfall,
#          lag0_sun_hours = avg_sun_hours,
#          lag0_temperature = avg_temperature,
#          lag0_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 1) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag1_humidity = avg_humidity,
#          lag1_rainfall = avg_rainfall,
#          lag1_sun_hours = avg_sun_hours,
#          lag1_temperature = avg_temperature,
#          lag1_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 2) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag2_humidity = avg_humidity,
#          lag2_rainfall = avg_rainfall,
#          lag2_sun_hours = avg_sun_hours,
#          lag2_temperature = avg_temperature,
#          lag2_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 3) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag3_humidity = avg_humidity,
#          lag3_rainfall = avg_rainfall,
#          lag3_sun_hours = avg_sun_hours,
#          lag3_temperature = avg_temperature,
#          lag3_wind_velocity = avg_wind_velocity) %>%
#   select(-join_date) %>%
#   mutate(lag0_3_humidity =
#            mean(c(lag0_humidity, lag1_humidity,
#                   lag2_humidity, lag3_humidity), na.rm = TRUE),
#          lag0_3_rainfall =
#            mean(c(lag0_rainfall, lag1_rainfall,
#                   lag2_rainfall, lag3_rainfall), na.rm = TRUE),
#          lag0_3_sun_hours =
#            mean(c(lag0_sun_hours, lag1_sun_hours,
#                   lag2_sun_hours, lag3_sun_hours), na.rm = TRUE),
#          lag0_3_temperature =
#            mean(c(lag0_temperature, lag1_temperature, 
#                   lag2_temperature, lag3_temperature), na.rm = TRUE),
#          lag0_3_wind_velocity =
#            mean(c(lag0_wind_velocity, lag1_wind_velocity, 
#                   lag2_wind_velocity, lag3_wind_velocity), na.rm = TRUE)) %>%
#   rename(lag0_date = date)
# 
# control_data_2_lag <-
#   control_data_2 %>%
#   left_join(parameter_data, by = c("sido", "date")) %>%
#   select(id, sido, gen, agg, influ, date,
#          avg_humidity, avg_rainfall, avg_sun_hours,
#          avg_temperature, avg_wind_velocity) %>%
#   rename(lag0_humidity = avg_humidity,
#          lag0_rainfall = avg_rainfall,
#          lag0_sun_hours = avg_sun_hours,
#          lag0_temperature = avg_temperature,
#          lag0_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 1) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag1_humidity = avg_humidity,
#          lag1_rainfall = avg_rainfall,
#          lag1_sun_hours = avg_sun_hours,
#          lag1_temperature = avg_temperature,
#          lag1_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 2) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag2_humidity = avg_humidity,
#          lag2_rainfall = avg_rainfall,
#          lag2_sun_hours = avg_sun_hours,
#          lag2_temperature = avg_temperature,
#          lag2_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 3) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag3_humidity = avg_humidity,
#          lag3_rainfall = avg_rainfall,
#          lag3_sun_hours = avg_sun_hours,
#          lag3_temperature = avg_temperature,
#          lag3_wind_velocity = avg_wind_velocity) %>%
#   select(-join_date) %>%
#   mutate(lag0_3_humidity =
#            mean(c(lag0_humidity, lag1_humidity,
#                   lag2_humidity, lag3_humidity), na.rm = TRUE),
#          lag0_3_rainfall =
#            mean(c(lag0_rainfall, lag1_rainfall,
#                   lag2_rainfall, lag3_rainfall), na.rm = TRUE),
#          lag0_3_sun_hours =
#            mean(c(lag0_sun_hours, lag1_sun_hours,
#                   lag2_sun_hours, lag3_sun_hours), na.rm = TRUE),
#          lag0_3_temperature =
#            mean(c(lag0_temperature, lag1_temperature, 
#                   lag2_temperature, lag3_temperature), na.rm = TRUE),
#          lag0_3_wind_velocity =
#            mean(c(lag0_wind_velocity, lag1_wind_velocity, 
#                   lag2_wind_velocity, lag3_wind_velocity), na.rm = TRUE)) %>%
#   rename(lag0_date = date)
# 
# control_data_3_lag <-
#   control_data_3 %>%
#   left_join(parameter_data, by = c("sido", "date")) %>%
#   select(id, sido, gen, agg, influ, date,
#          avg_humidity, avg_rainfall, avg_sun_hours,
#          avg_temperature, avg_wind_velocity) %>%
#   rename(lag0_humidity = avg_humidity,
#          lag0_rainfall = avg_rainfall,
#          lag0_sun_hours = avg_sun_hours,
#          lag0_temperature = avg_temperature,
#          lag0_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 1) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag1_humidity = avg_humidity,
#          lag1_rainfall = avg_rainfall,
#          lag1_sun_hours = avg_sun_hours,
#          lag1_temperature = avg_temperature,
#          lag1_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 2) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag2_humidity = avg_humidity,
#          lag2_rainfall = avg_rainfall,
#          lag2_sun_hours = avg_sun_hours,
#          lag2_temperature = avg_temperature,
#          lag2_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 3) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag3_humidity = avg_humidity,
#          lag3_rainfall = avg_rainfall,
#          lag3_sun_hours = avg_sun_hours,
#          lag3_temperature = avg_temperature,
#          lag3_wind_velocity = avg_wind_velocity) %>%
#   select(-join_date) %>%
#   mutate(lag0_3_humidity =
#            mean(c(lag0_humidity, lag1_humidity,
#                   lag2_humidity, lag3_humidity), na.rm = TRUE),
#          lag0_3_rainfall =
#            mean(c(lag0_rainfall, lag1_rainfall,
#                   lag2_rainfall, lag3_rainfall), na.rm = TRUE),
#          lag0_3_sun_hours =
#            mean(c(lag0_sun_hours, lag1_sun_hours,
#                   lag2_sun_hours, lag3_sun_hours), na.rm = TRUE),
#          lag0_3_temperature =
#            mean(c(lag0_temperature, lag1_temperature, 
#                   lag2_temperature, lag3_temperature), na.rm = TRUE),
#          lag0_3_wind_velocity =
#            mean(c(lag0_wind_velocity, lag1_wind_velocity, 
#                   lag2_wind_velocity, lag3_wind_velocity), na.rm = TRUE)) %>%
#   rename(lag0_date = date)
# 
# control_data_4_lag <-
#   control_data_4 %>%
#   left_join(parameter_data, by = c("sido", "date")) %>%
#   select(id, sido, gen, agg, influ, date,
#          avg_humidity, avg_rainfall, avg_sun_hours,
#          avg_temperature, avg_wind_velocity) %>%
#   rename(lag0_humidity = avg_humidity,
#          lag0_rainfall = avg_rainfall,
#          lag0_sun_hours = avg_sun_hours,
#          lag0_temperature = avg_temperature,
#          lag0_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 1) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag1_humidity = avg_humidity,
#          lag1_rainfall = avg_rainfall,
#          lag1_sun_hours = avg_sun_hours,
#          lag1_temperature = avg_temperature,
#          lag1_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 2) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag2_humidity = avg_humidity,
#          lag2_rainfall = avg_rainfall,
#          lag2_sun_hours = avg_sun_hours,
#          lag2_temperature = avg_temperature,
#          lag2_wind_velocity = avg_wind_velocity) %>%
#   mutate(join_date = date - 3) %>%
#   left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
#   rename(lag3_humidity = avg_humidity,
#          lag3_rainfall = avg_rainfall,
#          lag3_sun_hours = avg_sun_hours,
#          lag3_temperature = avg_temperature,
#          lag3_wind_velocity = avg_wind_velocity) %>%
#   select(-join_date) %>%
#   mutate(lag0_3_humidity =
#            mean(c(lag0_humidity, lag1_humidity,
#                   lag2_humidity, lag3_humidity), na.rm = TRUE),
#          lag0_3_rainfall =
#            mean(c(lag0_rainfall, lag1_rainfall,
#                   lag2_rainfall, lag3_rainfall), na.rm = TRUE),
#          lag0_3_sun_hours =
#            mean(c(lag0_sun_hours, lag1_sun_hours,
#                   lag2_sun_hours, lag3_sun_hours), na.rm = TRUE),
#          lag0_3_temperature =
#            mean(c(lag0_temperature, lag1_temperature, 
#                   lag2_temperature, lag3_temperature), na.rm = TRUE),
#          lag0_3_wind_velocity =
#            mean(c(lag0_wind_velocity, lag1_wind_velocity, 
#                   lag2_wind_velocity, lag3_wind_velocity), na.rm = TRUE)) %>%
#   rename(lag0_date = date)

case_data_lag <-
  case_data %>%
  left_join(parameter_data, by = c("sido", "date")) %>%
  select(id, sido, gen, agg, severity, influ, date,
         avg_humidity, avg_rainfall, avg_sun_hours,
         avg_temperature, avg_wind_velocity) %>%
  rename(lag0_humidity = avg_humidity,
         lag0_rainfall = avg_rainfall,
         lag0_sun_hours = avg_sun_hours,
         lag0_temperature = avg_temperature,
         lag0_wind_velocity = avg_wind_velocity) %>%
  mutate(join_date = date - 7) %>%
  left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
  rename(lag7_humidity = avg_humidity,
         lag7_rainfall = avg_rainfall,
         lag7_sun_hours = avg_sun_hours,
         lag7_temperature = avg_temperature,
         lag7_wind_velocity = avg_wind_velocity) %>%
  select(-join_date) %>%
  rename(lag0_date = date)

control_data_1_lag <-
  control_data_1 %>%
  left_join(parameter_data, by = c("sido", "date")) %>%
  select(id, sido, gen, agg, influ, date,
         avg_humidity, avg_rainfall, avg_sun_hours,
         avg_temperature, avg_wind_velocity) %>%
  rename(lag0_humidity = avg_humidity,
         lag0_rainfall = avg_rainfall,
         lag0_sun_hours = avg_sun_hours,
         lag0_temperature = avg_temperature,
         lag0_wind_velocity = avg_wind_velocity) %>%
  mutate(join_date = date - 7) %>%
  left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
  rename(lag7_humidity = avg_humidity,
         lag7_rainfall = avg_rainfall,
         lag7_sun_hours = avg_sun_hours,
         lag7_temperature = avg_temperature,
         lag7_wind_velocity = avg_wind_velocity) %>%
  select(-join_date) %>%
  rename(lag0_date = date)

control_data_2_lag <-
  control_data_2 %>%
  left_join(parameter_data, by = c("sido", "date")) %>%
  select(id, sido, gen, agg, influ, date,
         avg_humidity, avg_rainfall, avg_sun_hours,
         avg_temperature, avg_wind_velocity) %>%
  rename(lag0_humidity = avg_humidity,
         lag0_rainfall = avg_rainfall,
         lag0_sun_hours = avg_sun_hours,
         lag0_temperature = avg_temperature,
         lag0_wind_velocity = avg_wind_velocity) %>%
  mutate(join_date = date - 7) %>%
  left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
  rename(lag7_humidity = avg_humidity,
         lag7_rainfall = avg_rainfall,
         lag7_sun_hours = avg_sun_hours,
         lag7_temperature = avg_temperature,
         lag7_wind_velocity = avg_wind_velocity) %>%
  select(-join_date) %>%
  rename(lag0_date = date)

control_data_3_lag <-
  control_data_3 %>%
  left_join(parameter_data, by = c("sido", "date")) %>%
  select(id, sido, gen, agg, influ, date,
         avg_humidity, avg_rainfall, avg_sun_hours,
         avg_temperature, avg_wind_velocity) %>%
  rename(lag0_humidity = avg_humidity,
         lag0_rainfall = avg_rainfall,
         lag0_sun_hours = avg_sun_hours,
         lag0_temperature = avg_temperature,
         lag0_wind_velocity = avg_wind_velocity) %>%
  mutate(join_date = date - 7) %>%
  left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
  rename(lag7_humidity = avg_humidity,
         lag7_rainfall = avg_rainfall,
         lag7_sun_hours = avg_sun_hours,
         lag7_temperature = avg_temperature,
         lag7_wind_velocity = avg_wind_velocity) %>%
  select(-join_date) %>%
  rename(lag0_date = date)

control_data_4_lag <-
  control_data_4 %>%
  left_join(parameter_data, by = c("sido", "date")) %>%
  select(id, sido, gen, agg, influ, date,
         avg_humidity, avg_rainfall, avg_sun_hours,
         avg_temperature, avg_wind_velocity) %>%
  rename(lag0_humidity = avg_humidity,
         lag0_rainfall = avg_rainfall,
         lag0_sun_hours = avg_sun_hours,
         lag0_temperature = avg_temperature,
         lag0_wind_velocity = avg_wind_velocity) %>%
  mutate(join_date = date - 7) %>%
  left_join(parameter_data, by = c("sido", "join_date" = "date")) %>%
  rename(lag7_humidity = avg_humidity,
         lag7_rainfall = avg_rainfall,
         lag7_sun_hours = avg_sun_hours,
         lag7_temperature = avg_temperature,
         lag7_wind_velocity = avg_wind_velocity) %>%
  select(-join_date) %>%
  rename(lag0_date = date)

data1 <- 
  case_data_lag %>%
  filter(
      !is.na(lag0_humidity) &
      !is.na(lag0_rainfall) &
      !is.na(lag0_sun_hours) &
      !is.na(lag0_temperature) &
      !is.na(lag0_wind_velocity) &
      !is.na(lag7_humidity) &
      !is.na(lag7_rainfall) &
      !is.na(lag7_sun_hours) &
      !is.na(lag7_temperature) &
      !is.na(lag7_wind_velocity)
      )

data2 <- 
  control_data_1_lag %>%
  filter(
    !is.na(lag0_humidity) &
      !is.na(lag0_rainfall) &
      !is.na(lag0_sun_hours) &
      !is.na(lag0_temperature) &
      !is.na(lag0_wind_velocity) &
      !is.na(lag7_humidity) &
      !is.na(lag7_rainfall) &
      !is.na(lag7_sun_hours) &
      !is.na(lag7_temperature) &
      !is.na(lag7_wind_velocity)
  )

data3 <- 
  control_data_2_lag %>%
  filter(
    !is.na(lag0_humidity) &
      !is.na(lag0_rainfall) &
      !is.na(lag0_sun_hours) &
      !is.na(lag0_temperature) &
      !is.na(lag0_wind_velocity) &
      !is.na(lag7_humidity) &
      !is.na(lag7_rainfall) &
      !is.na(lag7_sun_hours) &
      !is.na(lag7_temperature) &
      !is.na(lag7_wind_velocity)
  )

data4 <- 
  control_data_3_lag %>%
  filter(
    !is.na(lag0_humidity) &
      !is.na(lag0_rainfall) &
      !is.na(lag0_sun_hours) &
      !is.na(lag0_temperature) &
      !is.na(lag0_wind_velocity) &
      !is.na(lag7_humidity) &
      !is.na(lag7_rainfall) &
      !is.na(lag7_sun_hours) &
      !is.na(lag7_temperature) &
      !is.na(lag7_wind_velocity)
  )

data5 <- 
  control_data_4_lag %>%
  filter(
    !is.na(lag0_humidity) &
      !is.na(lag0_rainfall) &
      !is.na(lag0_sun_hours) &
      !is.na(lag0_temperature) &
      !is.na(lag0_wind_velocity) &
      !is.na(lag7_humidity) &
      !is.na(lag7_rainfall) &
      !is.na(lag7_sun_hours) &
      !is.na(lag7_temperature) &
      !is.na(lag7_wind_velocity)
  )

final <- 
  data1 %>% bind_rows(data2) %>%
  bind_rows(data3) %>% bind_rows(data4) %>% bind_rows(data5)

target1 <- 
  final %>% group_by(id) %>%
  summarize(target1 = sum(influ)) %>%
  filter(target1 == 1)

target2 <-
  final %>% group_by(id) %>%
  summarize(cnt = n()) %>%
  filter(cnt > 1) %>%
  mutate(target2 = 1) %>%
  select(-cnt)

real_final <-
  final %>%
  left_join(target1, by = "id") %>%
  left_join(target2, by = "id") %>%
  filter(target1 == 1 & target2 == 1) %>% 
  arrange(id) %>%
  select(-c(target1, target2))

real_final %>% head(30)

real_final %>% distinct(id)

write.csv(
  real_final,
  "C:/SAS/NIPA_time_stratified_20231023/raw_data_20231023.csv",
  fileEncoding = "EUC-KR",
  row.names = FALSE
)





