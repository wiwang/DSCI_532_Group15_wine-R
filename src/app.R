library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)

library(dplyr)
library(ggplot2)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

wine_df <- read.csv("data/processed/wine.csv")
country_ids <- read.csv('data/geo/country-ids-revised.csv') 


#### dropdown list generation ####
country_dropdown_values <- list()
for (i in 1:nrow(country_ids)) {
  list_val <- list()
  list_val <- list(label = country_ids$name[i] , value = country_ids$name[i])
  country_dropdown_values[[i]] <- list_val
}
rm(list_val)
#### END ####



app$layout(
  dbcContainer(
    list(
      dbcRow( # Start of first row
          list( 
            dbcCol(
              list(
                htmlH1('Wine Valley'),
                htmlLabel('Country'),
                dccDropdown(
                  id='country_widget',
                  options = country_dropdown_values,
                  value = 'US',
                  multi = TRUE
                ),
                htmlLabel('Price'),
                dccRangeSlider(
                  id = "price_slider",
                  min=4, max=1500,
                  marks=list( '5' = '$5', '300'= '$300', '600' = '$600', '900' = '$900', '1200' = '$1200', '1500' = '$1500'),
                  value=list(4, 1500)
                ),
                htmlLabel('Wine Enthusiast Score'),
                dccRangeSlider(
                  id = 'score_slider',
                  min = 80, max = 100,
                  marks = list("80" = '80', "85" = '85', "90" = '90', "95" = '95', "100" = '100'),
                  value = list(80, 100)
                ),
                htmlLabel('Year'),
                dccRangeSlider(
                  id = 'year_slider',
                  min=1994, max=2017,
                  marks= list( '1994' = '1994', '1998'= '1998', '2003' = '2003', '2008' = '2008', '2013' = '2013', '2017' = '2017'),
                  value=list(1994, 2017)
                )
              ), md=4
            ), 
            dbcCol(
                list(
                  htmlH1('INSERT SCATTERPLOT HERE')
                  )
            ) 
          )
      ), # End of first row
      
      dbcRow( # Second row
        list( 
          dbcCol( 
            list(
              htmlH2('MAP GOES HERE!!!!!!')
            ), md=6
          ),
          dbcCol( 
            list(
              htmlH1('STATS GO HERE!!!!!!!!!')
            )
          )
        )
      ) # End of second row

    )
  )
)


app$run_server(debug = T)

