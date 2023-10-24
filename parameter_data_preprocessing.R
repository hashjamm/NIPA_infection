
# install packages and loading

library()

getwd()
setwd("C:/Users/HashJam/OneDrive/바탕 화면/Studies/Projects/NIPA_infection/20160101_20221231_매개변수_일별데이터")
getwd()

install.packages("data.table")
library(data.table)

# design for data pre-processing(parameter data tables)

fread(list.files(pattern = "강수량")[1], skip = 13, header = FALSE, select = c(1, 3, 4)) %>% rename("code" = "V1", "date" = "V3", "rainfall(mm)" = "V4") %>% head()

fread(list.files(pattern = "기온")[1], skip = 12, header = FALSE, select = c(1, 3, 4)) %>% rename("code" = "V1", "date" = "V3", "temperature(C)" = "V4") %>% head()

fread(list.files(pattern = "습도")[1], skip = 17, header = FALSE, select = c(1, 3, 4)) %>% rename("code" = "V1", "date" = "V3", "humidity(%rh)" = "V4") %>% head()

fread(list.files(pattern = "일조일사")[1], skip = 18, header = FALSE, select = c(1, 3, 4, 5, 6)) %>% rename("code" = "V1", "date" = "V3", "sun_hours(hr)" = "V4", "sun_percentage(%)" = "V5", "insolation(MJ/m²)" = "V6") %>% head()

fread(list.files(pattern = "풍속")[1], skip = 16, header = FALSE, select = c(1, 3, 4)) %>% rename("code" = "V1", "date" = "V3", "wind_velocity(m/s)" = "V4") %>% head()

# validation of design

for (name in list.files(pattern = "강수량")) {
  
  data <- fread(name, skip = 13, header = FALSE, select = c(3))[[1]]
  
  checkDate <- data[1]
  
  if (checkDate != "2016-01-01") {
    print(name)
    print(checkDate)
    print("=================")
  }
}

for (name in list.files(pattern = "기온")) {
  
  data <- fread(name, skip = 12, header = FALSE, select = c(3))[[1]]
  
  checkDate <- data[1]
  
  if (checkDate != "2016-01-01") {
    print(name)
    print(checkDate)
    print("=================")
  }
}

for (name in list.files(pattern = "습도")) {
  
  data <- fread(name, skip = 17, header = FALSE, select = c(3))[[1]]
  
  checkDate <- data[1]
  
  if (checkDate != "2016-01-01") {
    print(name)
    print(checkDate)
    print("=================")
  }
}

for (name in list.files(pattern = "일조일사")) {
  
  data <- fread(name, skip = 18, header = FALSE, select = c(3))[[1]]
  
  checkDate <- data[1]
  
  if (checkDate != "2016-01-01") {
    print(name)
    print(checkDate)
    print("=================")
  }
}

for (name in list.files(pattern = "풍속")) {
  
  data <- fread(name, skip = 16, header = FALSE, select = c(3))[[1]]
  
  checkDate <- data[1]
  
  if (checkDate != "2016-01-01") {
    print(name)
    print(checkDate)
    print("=================")
  }
}

# data pre-processing(parameter data tables)

## loading data

# =====일반적 코드로 하려다가 강수량부터 이상하게 받아져서 버린 코드 =====

# data_temp <- data.frame()
# index <- 0
# 
# for (filename in list.files(pattern = "기온")){
#   
#   index <- index + 1
#   
#   loaded_data <- fread(filename, header = FALSE, select = c(3)) %>% unlist()
#   
#   file_data <- data.frame()
#   
#   for(row_string in loaded_data) {
#     
#     unicode_error_skipped_row_string <- stri_unescape_unicode(row_string)
#     splitted_row_string <- strsplit(unicode_error_skipped_row_string , ",")
#     
#     line_data <- splitted_row_string %>% data.frame() %>% as.matrix() %>% t() %>% data.frame()
#     
#     rownames(line_data) <- NULL
#     
#     file_data <- file_data %>% bind_rows(line_data)
#     
#   }
#   
#   data_temp <- data_temp %>% bind_rows(file_data)
#   
#   rownames(data_temp) <- NULL
#   
#   print(paste(index, "file completed"))
#   
# }

### rainfall data

data_rainfall <- 
  fread(list.files(pattern = "강수량")[1], skip = 13, header = FALSE, select = c(1, 3, 4)) %>%
  rename("code" = "V1", "date" = "V3", "rainfall(mm)" = "V4")

index <- 0

for (filename in list.files(pattern = "강수량")) {
  
  index <- index + 1
  
  if (index == 1) {
    next
  }
  
  file_data <-
    fread(filename, skip = 13, header = FALSE, select = c(1, 3, 4)) %>%
    rename("code" = "V1", "date" = "V3", "rainfall(mm)" = "V4")
  
  data_rainfall <- data_rainfall %>% bind_rows(file_data)
  
}

rownames(data_rainfall) <- NULL

### temperature data

data_temp <- 
  fread(list.files(pattern = "기온")[1], skip = 12, header = FALSE, select = c(1, 3, 4)) %>% 
  rename("code" = "V1", "date" = "V3", "temperature(C)" = "V4")

index <- 0

for (filename in list.files(pattern = "기온")) {
  
  index <- index + 1
  
  if (index == 1) {
    next
  }
  
  file_data <-
    fread(filename, skip = 12, header = FALSE, select = c(1, 3, 4)) %>% 
    rename("code" = "V1", "date" = "V3", "temperature(C)" = "V4")
  
  data_temp <- data_temp %>% bind_rows(file_data)
  
}

rownames(data_temp) <- NULL

### humidity data

data_humidity <- 
  fread(list.files(pattern = "습도")[1], skip = 17, header = FALSE, select = c(1, 3, 4)) %>% 
  rename("code" = "V1", "date" = "V3", "humidity(%rh)" = "V4")

index <- 0

for (filename in list.files(pattern = "습도")) {
  
  index <- index + 1
  
  if (index == 1) {
    next
  }
  
  file_data <-
    fread(filename, skip = 17, header = FALSE, select = c(1, 3, 4)) %>% 
    rename("code" = "V1", "date" = "V3", "humidity(%rh)" = "V4")
  
  data_humidity <- data_humidity %>% bind_rows(file_data)
  
}

rownames(data_humidity) <- NULL

### sunshine data

data_sunshine <- 
  fread(list.files(pattern = "일조일사")[1], skip = 18, header = FALSE, select = c(1, 3, 4, 5, 6)) %>%
  rename("code" = "V1",
         "date" = "V3",
         "sun_hours(hr)" = "V4",
         "sun_percentage(%)" = "V5",
         "insolation(MJ/m²)" = "V6")

index <- 0

for (filename in list.files(pattern = "일조일사")) {
  
  index <- index + 1
  
  if (index == 1) {
    next
  }
  
  file_data <-
    fread(filename, skip = 18, header = FALSE, select = c(1, 3, 4, 5, 6)) %>%
    rename("code" = "V1",
           "date" = "V3",
           "sun_hours(hr)" = "V4",
           "sun_percentage(%)" = "V5",
           "insolation(MJ/m²)" = "V6")
  
  data_sunshine <- data_sunshine %>% bind_rows(file_data)
  
}

rownames(data_sunshine) <- NULL

### wind data

data_wind <- 
  fread(list.files(pattern = "풍속")[1], skip = 16, header = FALSE, select = c(1, 3, 4)) %>%
  rename("code" = "V1", "date" = "V3", "wind_velocity(m/s)" = "V4")

index <- 0

for (filename in list.files(pattern = "풍속")) {
  
  index <- index + 1
  
  if (index == 1) {
    next
  }
  
  file_data <-
    fread(filename, skip = 16, header = FALSE, select = c(1, 3, 4)) %>%
    rename("code" = "V1", "date" = "V3", "wind_velocity(m/s)" = "V4")
  
  data_wind <- data_wind %>% bind_rows(file_data)
  
}

rownames(data_wind) <- NULL

### data check

data_temp %>% head(20)
data_temp %>% str()

data_humidity %>% head(20)
data_humidity %>% str()

data_rainfall %>% head(20)
data_rainfall %>% str()

data_sunshine %>% head(20)
data_sunshine %>% str()

data_wind %>% head(20)
data_wind %>% str()

### wind 파일의 개수가 달라서 이를 해결하기 위해서 자세히 뜯어본 코드 

temp = data_temp %>% select(code) %>% distinct()
humidity = data_humidity %>% select(code) %>% distinct()
sunshine = data_sunshine %>% select(code) %>% distinct()
rainfall = data_rainfall %>% select(code) %>% distinct()
wind = data_wind %>% select(code) %>% distinct()
# 
# for (i in 1:96) {
#   
#   if (
#     
#     all(temp[i] == humidity[i],
#         humidity[i] == sunshine[i],
#         sunshine[i] == rainfall[i],
#         rainfall[i] == wind[i])
#     
#   ) {
#     
#     next
#     
#   } else {
#     
#     print(i)
#     print(paste("temp :", temp[i]))
#     print(paste("humidity :", humidity[i]))
#     print(paste("sunshine :", sunshine[i]))
#     print(paste("rainfall :", rainfall[i]))
#     print(paste("wind :", wind[i]))
#     
#   }
#   
# }

identical(temp, humidity)
identical(humidity, sunshine)
identical(sunshine, rainfall)
identical(rainfall, wind)

##

# data pre-processing(influenza data tables)

## loading influenza data

setwd("C:/Users/HashJam/OneDrive/바탕 화면/Studies/Projects/NIPA_infection")

data_influ_sheet1 <- 
  read_xlsx("influenza_nationwide_221231.xlsx", sheet = "외래입원주부상병") %>%
  mutate(SEVERITY = 1)

data_influ_sheet2 <- 
  read_xlsx("influenza_nationwide_221231.xlsx", sheet = "입원주부상병") %>%
  mutate(SEVERITY = 2)

data_influ_sheet3 <- 
  read_xlsx("influenza_nationwide_221231.xlsx", sheet = "시도코드")

data_influ_sheet4 <-
  read_xlsx("influenza_nationwide_221231.xlsx", sheet = "시군구코드(말소코드포함)")

## matching table : "location code - measurement location code"

setwd("C:/Users/HashJam/OneDrive/바탕 화면/Studies/Projects/NIPA_infection/20160101_20221231_매개변수_일별데이터")

location_info_vector_from_filenames <-
  lapply(list.files(pattern = "기온"),
         function(x) strsplit(x, "_일평균기온_2016_2022.csv")) %>%
  unlist()

location_info_table <-
  lapply(location_info_vector_from_filenames,
       function(x) strsplit(x, "_")) %>%
  data.frame() %>%
  as.matrix() %>%
  t() %>%
  data.frame()

rownames(location_info_table) <- NULL

location_info_table <- 
  location_info_table %>%
  bind_cols(temp) %>%
  rename("sido_name" = "X1", "detail_location" = "X2")

location_info_table %>% head()

location_info_table <-
  location_info_table %>%
  merge(data_influ_sheet3, all.x = TRUE, by.x = "sido_name", by.y = "시도명")

location_info_table <-
  location_info_table %>%
  rename(SIDO = "시도코드") %>%
  mutate(SIDO = if_else(is.na(SIDO), 50, SIDO))

location_info_table %>% head()

## arranging influenza data tables

data_influ <-
  data_influ_sheet1 %>%
  bind_rows(data_influ_sheet2)

data_influ <-
  data_influ %>%
  rename("date" = "FST_DT") %>%
  select(SIDO, date, GEN, AGG, SEVERITY, CNT) %>%
  arrange(SIDO, date, GEN, AGG, SEVERITY)

arranged_influ_data <-
  data_influ %>% select(SIDO, date, CNT) %>% group_by(SIDO, date) %>% summarize(confirmed_num = sum(CNT))

## data merging process

### parameter data + location data

matched_data_humidity <-
  data_humidity %>% 
  merge(location_info_table, all.x = TRUE, by = "code") %>%
  select(SIDO, sido_name, detail_location, code, date, `humidity(%rh)`)

matched_data_rainfall <-
  data_rainfall %>%
  merge(location_info_table, all.x = TRUE, by = "code") %>%
  select(SIDO, sido_name, detail_location, code, date, `rainfall(mm)`)

# matched_data_rainfall %>% filter(!is.na(`rainfall(mm)`))

matched_data_sunshine <-
  data_sunshine %>%
  merge(location_info_table, all.x = TRUE, by = "code") %>%
  select(SIDO, sido_name, detail_location, code, date, `sun_hours(hr)`,
         `sun_percentage(%)`, `insolation(MJ/m²)`)

matched_data_temp <-
  data_temp %>%
  merge(location_info_table, all.x = TRUE, by = "code") %>%
  select(SIDO, sido_name, detail_location, code, date, `temperature(C)`)

matched_data_wind <-
  data_wind %>%
  merge(location_info_table, all.x = TRUE, by = "code") %>%
  select(SIDO, sido_name, detail_location, code, date, `wind_velocity(m/s)`)

### calculating average amount group by SIDO

avg_mt_dt_humidity <-
  matched_data_humidity %>% 
  select(SIDO, date, `humidity(%rh)`) %>%
  group_by(SIDO, date) %>%
  summarise("avg_humidity(%rh)" = mean(`humidity(%rh)`))
  
avg_mt_dt_rainfall <-
  matched_data_rainfall %>% 
  select(SIDO, date, `rainfall(mm)`) %>%
  group_by(SIDO, date) %>%
  summarise("avg_rainfall(mm)" = mean(`rainfall(mm)`))

# avg_mt_dt_rainfall %>% filter(!is.na(`avg_rainfall(mm)`))

avg_mt_dt_sunshine <-
  matched_data_sunshine %>% 
  select(SIDO, date, `sun_hours(hr)`, `sun_percentage(%)`, `insolation(MJ/m²)`) %>%
  group_by(SIDO, date) %>%
  summarise("avg_sun_hours(hr)" = mean(`sun_hours(hr)`),
            "avg_sun_percentage(%)" = mean(`sun_percentage(%)`),
            "avg_insolation(MJ/m²)" = mean(`insolation(MJ/m²)`)
            )

avg_mt_dt_temp <-
  matched_data_temp %>% 
  select(SIDO, date, `temperature(C)`) %>%
  group_by(SIDO, date) %>%
  summarise("avg_temperature(C)" = mean(`temperature(C)`))

avg_mt_dt_wind <-
  matched_data_wind %>% 
  select(SIDO, date, `wind_velocity(m/s)`) %>%
  group_by(SIDO, date) %>%
  summarise("avg_wind_velocity(m/s)" = mean(`wind_velocity(m/s)`))

### parameter data + influenza data + location data + final data pre-processing

arranged_influ_data <-
  arranged_influ_data %>% mutate(date = as.Date(as.character(date), "%Y%m%d"))

final_data <-
  arranged_influ_data %>% 
  merge(avg_mt_dt_humidity, all.x = TRUE, by = c("SIDO", "date")) %>%
  merge(avg_mt_dt_rainfall, all.x = TRUE, by = c("SIDO", "date")) %>%
  merge(avg_mt_dt_sunshine, all.x = TRUE, by = c("SIDO", "date")) %>%
  merge(avg_mt_dt_temp, all.x = TRUE, by = c("SIDO", "date")) %>%
  merge(avg_mt_dt_wind, all.x = TRUE, by = c("SIDO", "date"))

# 문자 인식 문제로 따로 지정
colnames(final_data)[colnames(final_data) == "avg_insolation(MJ/m²)"] <- "avg_insolation(MJ/m2)"

real_final_data <-
  final_data %>%
  filter(date >= as.Date('2016-01-01') & date <= as.Date('2022-12-31')) %>%
  merge(data_influ_sheet3, all.x = TRUE, by.x = "SIDO", by.y = "시도코드") %>%
  rename("sido_name" = "시도명",
         "sido" = "SIDO",
         "avg_insolation" = "avg_insolation(MJ/m2)",
         "avg_humidity" = "avg_humidity(%rh)",
         "avg_rainfall" = "avg_rainfall(mm)",
         "avg_sun_hours" = "avg_sun_hours(hr)",
         "avg_sun_percentage" = "avg_sun_percentage(%)",
         "avg_insolation" = "avg_insolation(MJ/m2)",
         "avg_temperature" = "avg_temperature(C)",
         "avg_wind_velocity" = "avg_wind_velocity(m/s)") %>%
  select(
    sido, sido_name, date, confirmed_num, avg_humidity,
    avg_rainfall, avg_sun_hours, avg_sun_percentage,
    avg_insolation, avg_temperature, avg_wind_velocity
    )

### export final data

write.csv(
  real_final_data,
  "C:/Users/HashJam/OneDrive/바탕 화면/Studies/Projects/\
  NIPA_infection/20230907_매개변수_전처리완료데이터/전국.csv",
  fileEncoding = "EUC-KR",
  row.names = FALSE
  )

split_real_final_data <-
  real_final_data %>% group_by(sido) %>% group_split()

for (i in seq_along(split_real_final_data)) {
  
  split_data <- split_real_final_data[[i]]
  
  filename <- split_data %>% distinct(sido_name)
  
  split_data <- split_data %>% select(-c("sido", "sido_name"))
  
  write.csv(
    split_data,
    paste0("C:/Users/HashJam/OneDrive/바탕 화면/Studies/Projects/",
            "NIPA_infection/20230907_매개변수_전처리완료데이터/",
            filename,
            ".csv"),
    fileEncoding = "EUC-KR",
    row.names = FALSE
  )
  
}
