## ---- libraries
library(curl)
library(tidyverse)
library(berryFunctions)
library(tidyverse)


## ---- covid
tmp <- tempfile()
curl_download("https://cloud.minsa.gob.pe/s/Y8w3wHsEdYQSZRp/download", tmp)
df <- read_csv(tmp)

## ---- movilization
tmp <- tempfile()
curl_download("https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv", tmp)
read_csv(tmp, col_types = "ccccDdddddd") %>%
    filter(country_region_code == "PE") -> df_mov

## ---- infec
df %>%
    group_by(FECHA_RESULTADO) %>%
    summarise(N = n()) %>%
    mutate(FECHA_RESULTADO = lubridate::dmy(FECHA_RESULTADO)) %>%
    arrange(FECHA_RESULTADO) %>%
    mutate(NSUM = cumsum(N)) -> df_infec

## ---- plot_new_cases
plot_new_cases <- function(min_day, max_day, main_title) {
    df_infec %>%
        filter(FECHA_RESULTADO >= min_day & FECHA_RESULTADO <= max_day) -> df_tmp

    df_tmp %>%
        plot(N~FECHA_RESULTADO, data = ., main = main_title, xlab = "Fecha", ylab = "Nuevos casos")

    abline(h = mean(df_tmp$N), col = "red")
    abline(h = median(df_tmp$N), col = "blue")
}

## ---- plot_sum_cases
plot_sum_cases <- function(min_day, max_day, main_title) {
    df_infec %>%
        filter(FECHA_RESULTADO >= min_day & FECHA_RESULTADO <= max_day) -> df_tmp

    df_tmp %>%
        plot(NSUM~FECHA_RESULTADO, data = ., main = main_title, xlab = "Fecha", ylab = "Casos totales")

    abline(h = mean(df_tmp$NSUM), col = "red")
    abline(h = median(df_tmp$NSUM), col = "blue")
}

## ---- plot_rmoves
plot_rmoves <- function(min_day, max_day, main_title) {
    df_mov %>%
        group_by(date) %>%
        summarise(mov = mean(retail_and_recreation_percent_change_from_baseline, na.rm = TRUE)) %>%
        filter(date >= min_day & date <= max_day) -> df_tmp

    df_tmp %>%
        plot(main = main_title, xlab = "Fecha", ylab = "Cambio de movilizacion")

    abline(h = mean(df_tmp$mov), col = "red")
    abline(h = median(df_tmp$mov), col = "blue")
}

## ---- cat_function
cat_function <- function(f_name, min_day, max_day) {
    cat("```{r}\n")
    cat(f_name)
    cat("(\"")
    cat(min_day)
    cat("\", \"")
    cat(max_day)
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
cat_plot <- function(min_day, max_day, main_title, fun, title, text = "") {
    cat_title(title, min_day, max_day)
    cat_function(berryFunctions::getName(fun), min_day, max_day)

    cat("<div style=\"float: left\">\n")
        fun(min_day, max_day, main_title)
    cat("</div>\n")

    cat("<div>\n")
        cat(text)
    cat("</div>\n")
}

## ---- repeat_plots
repeat_plots <- function(min_day, max_day, main_title = "", text1 = "", text2 = "", text3 = "") {
    cat_plot(min_day, max_day, main_title, plot_new_cases, "Nuevos casos", text1)
    cat_plot(min_day, max_day, main_title, plot_sum_cases, "Casos totales", text2)
    cat_plot(min_day, max_day, main_title, plot_rmoves, "Movilización recreacional", text3)
}
