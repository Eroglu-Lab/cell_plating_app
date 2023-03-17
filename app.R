#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Cell Plating Calculator"),

    textInput(inputId = "initialCellConcentration",
              label = "Enter Initial Cell Concentration in millions of cells per mL",
              value = "6"),
    
    textInput(inputId = "desiredPlatingDensity",
              label = "Enter the desired plating density in thousands of cells",
              value = "100"),
    
    textInput(inputId = "desiredNumWells",
              label = "Enter the number of wells to be plated",
              value = "24"),
    
    textInput(inputId = "desiredPlatingVolume",
              label = "Enter the desired plating volume in microliters",
              value = "100"),
    
    h4("Move this volume of cells into a new tube"),
    
    textOutput(outputId = "text1"),
    
    h4("Add this volume of media to your new cell tube"),
    
    textOutput(outputId = "text2"),
    
    h4("Mix cells and distribute the entered plating volume to each well"),
    
    h5("*Note: calculations provide exact volumes, add extra wells if you can to account for pipetting error")
)

# Define server logic 
server <- function(input, output) {

    doCalc <- function() {
      #initial concentration of cells in thousands per ul = millions per ml
      initial_cells_per_ul <- as.double(input$initialCellConcentration)
      
      #the volume of the original cells each well would need 
      #this is just the desired density in k divided by the initial ul/k
      initial_vol_per_well <- as.double(input$desiredPlatingDensity) / initial_cells_per_ul
      
      #total volume of the inital cell solution needed for the desired numWells
      #this volume of cells can be set aside in a new tube for dilution
      initial_vol_all_wells <- initial_vol_per_well * as.double(input$desiredNumWells)
      
      out_string_1 <- paste("Volume of cells needed (uL):", initial_vol_all_wells)
      
      return(out_string_1)
      
    }
    
    doCalc2 <- function() {
      #initial concentration of cells in thousands per ul = millions per ml
      initial_cells_per_ul <- as.double(input$initialCellConcentration)
      
      #the volume of the original cells each well would need 
      #this is just the desired density in k divided by the initial ul/k
      initial_vol_per_well <- as.double(input$desiredPlatingDensity) / initial_cells_per_ul
      
      #total volume of the inital cell solution needed for the desired numWells
      #this volume of cells can be set aside in a new tube for dilution
      initial_vol_all_wells <- initial_vol_per_well * as.double(input$desiredNumWells)
      
      #the total volume for the cells if they were diluted to the right concentration
      desired_total_volume <- as.double(input$desiredNumWells) * as.double(input$desiredPlatingVolume)
      
      #find how much media to add to dilute the cells up to the desired volume
      #this volume of media can be added to the cells set aside previously
      #the resulting diluted cells can then be plated using the desired volume
      dilution_vol <- desired_total_volume - initial_vol_all_wells
      
      out_string_2 <- paste("Volume of media needed (uL):", dilution_vol)
      
      return(out_string_2)
      
    }
    
    output$text1 <- renderText({
      doCalc()
    }) 
    output$text2 <- renderText({
      doCalc2()
    }) 
    
}

# Run the application 
shinyApp(ui = ui, server = server)
