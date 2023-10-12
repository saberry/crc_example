library(doParallel)
library(foreach)
library(parallel)

rail <- read.csv(
  "/afs/crc.nd.edu/user/s/sberry5/wrangling_test/Rail_Equipment_Accident_Incident_Data.csv"
  )

rail$casualty <- rail$Total.Persons.Injured + rail$Total.Persons.Killed

subset_data <- rail[, c("casualty", "Temperature", 
                        "Loaded.Freight.Cars", "Minutes.Conductors.On.Duty")]

bootstraps <- 100000

options(cores = Sys.getenv("NSLOTS"))
getOption('cores')

foreach_bootstrap <- foreach(i = 1:bootstraps, .combine = "rbind") %dopar% {
  
  sample_rows <- sample(x = 1:nrow(subset_data), 
                        size = 10000, 
                        replace = TRUE)
  
  sample_data <- subset_data[sample_rows, ]
  
  simple_model <- lm(casualty ~ Temperature + Loaded.Freight.Cars + Minutes.Conductors.On.Duty, 
                     data = sample_data)
  
  model_summary <- summary(simple_model)
  
  t_result <- data.frame(t(model_summary$coefficients[, 't value']))
  
  t_result
}

save(
  foreach_bootstrap, 
  file = "/afs/crc.nd.edu/user/s/sberry5/wrangling_test/big_boot_out.RData"
)

proc.time()
