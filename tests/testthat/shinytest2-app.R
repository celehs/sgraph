library(testthat)
library(shinytest2)
library(sgraph)

# Helper function: Check if shinytest2 is installed
check_shinytest2 <- function() {
  skip_if_not_installed("shinytest2")
  message("shinytest2 is installed, test continues")
}

# Helper function: Get and check application directory
get_app_dir <- function(app_path) {
  app_dir <- system.file(app_path, package = "sgraph")
  skip_if_not(dir.exists(app_dir), paste0(app_path, " directory does not exist"))
  message(app_path, " directory exists, test continues")
  return(app_dir)
}

# Helper function: Create test application
create_test_app <- function(app_dir, name, ...) {
  message("Creating test application...")
  app <- AppDriver$new(app_dir, name = name, 
                     height = 800, width = 1200, 
                     variant = platform_variant(),
                     ...)
  message("Test application created successfully")
  return(app)
}

# Helper function: Test if application loads and renders successfully
test_app_loading <- function(app, check_legend = TRUE) {
  message("Testing if application is loaded...")
  kg_exists <- app$get_js("document.getElementById('kg') !== null")
  expect_true(kg_exists)
  if(kg_exists) message("sgraphOutput('kg') element exists")
  
  if(check_legend) {
    message("Testing if legend panel exists...")
    legend_exists <- app$get_js("document.getElementById('legend') !== null")
    expect_true(legend_exists)
    if(legend_exists) message("Legend panel exists")
  }
  
  message("Testing if graph renders correctly...")
  canvas_exists <- app$get_js("document.querySelector('canvas') !== null")
  expect_true(canvas_exists)
  if(canvas_exists) message("Canvas element exists, graph has rendered")
}

# Helper function: Close test application
close_test_app <- function(app) {
  message("Closing test application...")
  app$stop()
  message("Test application closed")
}
#----------------------------------------------------------

# Test 1: Verify label_grid_cell_size parameter is correctly passed
test_that("label_grid_cell_size parameter is correctly passed", {
  # Check if shinytest2 is installed
  check_shinytest2()
  Sys.setenv(LABEL_GRID_CELL_SIZE = 100)
  # Get application directory
  app_dir1 <- get_app_dir("shiny-server/shiny_app")
  # Create test application
  app1 <- create_test_app(app_dir1,  "sgraph_app_test_100")
  # Test if application loads and renders successfully
  test_app_loading(app1)
  # Get application settings
  app1_settings <- app1$get_value(output = "kg")
  app1_data <- jsonlite::fromJSON(app1_settings)
  label_grid_cell_size_1 <- app1_data$x$options$label_grid_cell_size
  label_size_1 <- app1_data$x$options$label_size
  # Close test application
  close_test_app(app1)
  
  Sys.setenv(LABEL_GRID_CELL_SIZE = 400)
  
  # Create test application
  app1 <- create_test_app(app_dir1,  "sgraph_app_test_100")
  
  # Test if application loads and renders successfully
  test_app_loading(app1)
  # Get application settings
  app1_settings <- app1$get_value(output = "kg")
  app1_data <- jsonlite::fromJSON(app1_settings)
  label_grid_cell_size_2 <- app1_data$x$options$label_grid_cell_size
  label_size_2 <- app1_data$x$options$label_size
  
  # Close test application
  close_test_app(app1)

  message("Application 1 (label_grid_cell_size = ",") settings: ", label_grid_cell_size_1)
  message("Application 1 label_size setting: ", label_size_1)
  message("Application 2 (label_grid_cell_size = 100) settings: ", label_grid_cell_size_2)
  message("Application 2 label_size setting: ", label_size_2)
  
  # Compare label_size between two applications
  expect_false(label_size_1 == label_size_2, 
               info = "label_size should be different between the two applications")
  Sys.setenv(LABEL_GRID_CELL_SIZE = 100)
  
})
