library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)

library(dplyr)
library(ggplot2)
library(plotly)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

wine_df <- read.csv("data/processed/wine.csv")
country_ids <- read.csv('data/geo/country-ids-revised.csv') 

#### data wrangling for map ####
map_df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv")
map_df <- map_df %>% 
  mutate(COUNTRY = replace(COUNTRY, COUNTRY == "United States", "US"))
wine_countrycode <- left_join(wine_df, map_df, by = c("country"="COUNTRY"))

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
                  value = c('US'),
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
                  #htmlH1('INSERT SCATTERPLOT HERE')
                  dccGraph(id='scatter-plot')
                  )
            ) 
          )
      ), # End of first row
      
      dbcRow( # Second row
        list( 
          dbcCol( 
            list(
              #htmlH2('MAP GOES HERE!!!!!!')
              dccGraph(id='map-area')
            ), md=6
          ),
          dbcCol( 
            list(
              dccGraph(id='stats-plot')
              #htmlH1('STATS GO HERE!!!!!!!!!')
            )
          )
        )
      ) # End of second row

    )
  )
)

app$callback(
  output('scatter-plot', 'figure'),
  params = list(input('country_widget', 'value')),
  function(xcol) {
    selected_countries = xcol 
    #!!sym(xcol)
    #selected_countries = !!sym(xcol)
    wine_country = wine_df %>% filter(country %in% selected_countries)
    wine_country =  wine_country %>% slice_max(order_by = points, n = 15)
    
    # filter by price and year
    #wine_country = wine_country %>% 
    #  filter((price >= price_range[1]) & (price <= price_range[2]) &
    #           (year >= year_range[1]) & (year <= year_range[2]))
    
    p <- ggplot(wine_country) +
      #%>% filter(country %in% !!sym(xcol))) +
      aes(x = price,
          y = points,
          color = country) +
      geom_point() +
      scale_x_log10() +
      ggthemes::scale_color_tableau()
    ggplotly(p)
  }
)

app$callback(
  output('stats-plot', 'figure'),
  list(input('country_widget', 'value')),
  function(xcol, price_range = list(4, 1500), year_range = list(1900, 2017)) {
    selected_countries = xcol #!!sym(xcol)
    wine_country = wine_df %>% filter(country %in% selected_countries)
    wine_country =  wine_country %>% slice_max(order_by = points, n = 15)
    
    # filter by price and year
    #wine_country <- wine_country %>% 
    # filter((price >= price_range[1]) & (price <= price_range[2]) 
    #       & (year >= year_range[1]) & (year <= year_range[2]))
    
    
    p_1 <- ggplot(wine_country) +
      aes(x = points,
          y = reorder(variety, -points),
          fill = country) +
      #geom_point() +
      geom_bar(stat = 'identity', position=position_dodge()) +
      xlab("Rating Score") +
      ylab("Variety") +
      ggtitle("Average Rating of Top 15 Best Rated Wine") +
      theme(plot.title = element_text(hjust = 0.5)) +
      ggthemes::scale_color_tableau()
    
    p_2 <- ggplot(wine_country) +
      aes(x = price,
          y = reorder(variety, -price),
          fill = country) +
      geom_bar(stat = 'identity', position=position_dodge()) +  
      xlab("Price") +
      ylab("Variety") +
      ggtitle("Average Price of Top 15 Best Rated Wine") +
      theme(plot.title = element_text(hjust = 0.5)) +
      ggthemes::scale_color_tableau() 
    
    subplot(ggplotly(p_1), ggplotly(p_2), nrows = 1, shareY=FALSE, titleX = TRUE)
    
  }
)


app$callback(
  output('map-area', 'figure'),
  list(input('price_slider', 'value'),
       input('score_slider', 'value'),
       input('year_slider', 'value')),
  function(price_range = list(4,1500), points_range = list(80,100), year_range = list(1900, 2017)) {
    # filter criteria
    wine_countrycode <- wine_countrycode %>% 
      filter(price >= price_range[[1]] & price <= price_range[[2]] & 
               points >= points_range[[1]] & points<= points_range[[2]] &
               year >= year_range[[1]] & year<= year_range[[2]])
    
    # data wrangling
    wine_counts <- wine_countrycode %>% 
      group_by(CODE, country) %>%
      summarize(counts = n())
    
    # draw map
    map_fig <- plot_ly(wine_counts, type='choropleth', locations=~CODE, z=~counts)
    
    # format
    map_fig <- map_fig %>% layout(title = list(text = 'Wine Producing Map'))
    
    ggplotly(map_fig)
  })



app$run_server(debug = T)

