## ---- libraries
library(curl)
library(tidyverse)
library(berryFunctions)


## ---- covid
tmp <- tempfile()
curl_download("https://cloud.minsa.gob.pe/s/Y8w3wHsEdYQSZRp/download", tmp)

readLines(tmp) %>%
    iconv(from = "ISO-8859-1", to = "UTF-8") %>%
    read_csv() %>%
    mutate(FECHA_RESULTADO = lubridate::dmy(FECHA_RESULTADO)) -> df

## ---- movilization
tmp <- tempfile()
curl_download("https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv", tmp)
read_csv(tmp, col_types = "cccccdDdddddd") %>%
    filter(country_region_code == "PE") -> df_mov

## ---- infec
df %>%
    group_by(FECHA_RESULTADO) %>%
    summarise(N = n()) %>%
    arrange(FECHA_RESULTADO) %>%
    mutate(NSUM = cumsum(N)) -> df_infec

## ---- plot_new_cases
plot_new_cases <- function(day, min_day, max_day, main_title) {
    df_infec %>%
        filter(FECHA_RESULTADO >= min_day & FECHA_RESULTADO <= max_day) -> df_tmp

    df_infec %>%
        filter(FECHA_RESULTADO >= min_day & FECHA_RESULTADO < day) -> df_tmp_a

    df_infec %>%
        filter(FECHA_RESULTADO > day & FECHA_RESULTADO <= max_day) -> df_tmp_b

    df_tmp %>%
        plot(N~FECHA_RESULTADO, data = ., main = main_title, xlab = "Fecha", ylab = "Nuevos casos")

    mean1 <- mean(df_tmp_a$N)
    segments(as.Date(min_day)-1, mean1, as.Date(day), mean1, col = "red")
    
    median1 <- median(df_tmp_a$N)
    segments(as.Date(min_day)-1, median1, as.Date(day), median1, col = "blue")

    mean2 <- mean(df_tmp_b$N)
    segments(as.Date(day), mean2, as.Date(max_day)+1, mean2, col = "red", lty = 2)
    
    median2 <- median(df_tmp_b$N)
    segments(as.Date(day), median2, as.Date(max_day)+1, median2, col = "blue", lty = 2)

    legend("topright", legend=c("Promedio antes", "Mediana antes", "Promedio después", "Mediana después"),
       col=c("red", "blue", "red", "blue"), lty=c(1,1,2,2), cex=0.8)
}

## ---- plot_sum_cases
plot_sum_cases <- function(day, min_day, max_day, main_title) {
    df_infec %>%
        filter(FECHA_RESULTADO >= min_day & FECHA_RESULTADO <= max_day) %>%
        plot(NSUM~FECHA_RESULTADO, data = ., main = main_title, xlab = "Fecha", ylab = "Casos totales")
}

## ---- plot_rmoves
plot_rmoves <- function(day, min_day, max_day, main_title) {
    df_mov %>%
        group_by(date) %>%
        summarise(mov = mean(retail_and_recreation_percent_change_from_baseline, na.rm = TRUE)) -> df_tmp

    df_tmp %>% filter(date >= min_day & date < day) -> df_tmp_a
    df_tmp %>% filter(date > day & date <= max_day) -> df_tmp_b
    df_tmp %>% filter(date >= min_day & date <= max_day) -> df_tmp

    df_tmp %>%
        plot(main = main_title, xlab = "Fecha", ylab = "Cambio de movilizacion")

    mean1 <- mean(df_tmp_a$mov)
    segments(as.Date(min_day)-1, mean1, as.Date(day), mean1, col = "red")
    
    median1 <- median(df_tmp_a$mov)
    segments(as.Date(min_day)-1, median1, as.Date(day), median1, col = "blue")

    mean2 <- mean(df_tmp_b$mov)
    segments(as.Date(day), mean2, as.Date(max_day)+1, mean2, col = "red", lty = 2)
    
    median2 <- median(df_tmp_b$mov)
    segments(as.Date(day), median2, as.Date(max_day)+1, median2, col = "blue", lty = 2)

    legend("topright", legend=c("Promedio antes", "Mediana antes", "Promedio después", "Mediana después"),
       col=c("red", "blue", "red", "blue"), lty=c(1,1,2,2), cex=0.8)
}

## ---- cat_function
cat_function <- function(f_name, min_day, max_day) {
    cat("```{r}\n")
    cat(f_name)
    cat("(\"")
    cat(format(as.Date(min_day), "%Y-%m-%d"))
    cat("\", \"")
    cat(format(as.Date(max_day), "%Y-%m-%d"))
    cat("\")\n```\n\n")
}

## ---- cat_title
cat_title <- function(f_title, min_day, max_day) {
    cat("##",
        f_title,
        format(as.Date(min_day), "%m-%d"),
        "->",
        format(as.Date(max_day), "%m-%d"),
        "\n"
    )
}

## ---- cat_plot
cat_plot <- function(day, range,  main_title, fun, title) {
    min_day <- day - range
    max_day <- day + range

    cat_title(title, min_day, max_day)
    cat_function(berryFunctions::getName(fun), min_day, max_day)

    # Print date in title
    date_str <- paste("(",format(as.Date(day), "%Y-%m-%d") ,")", sep="")
    fun(day, min_day, max_day, paste(main_title, date_str))
    abline(v = as.Date(day))

    cat("\n.\n\n\n")
}

## ---- repeat_plots
repeat_plots <- function(day, range, main_title = "") {
    day <- lubridate::ymd(day)
    cat_plot(day, range, main_title, plot_new_cases, "Nuevos casos")
    #cat_plot(day, range, main_title, plot_sum_cases, "Casos totales")
    cat_plot(day, range, main_title, plot_rmoves, "Movilización recreacional")
}
