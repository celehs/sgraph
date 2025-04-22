

test_shiny_app = function() {

  dirpath = system.file('extdata', package = 'sgraph')
  kgraph = get(load(file.path(dirpath, 'epmc_1700_cuis_kg.rds')))
  lgraph = kgraph_to_lgraph(kgraph)

  # test multiline labels and color_map
  lgraph$df_nodes$cui = lgraph$df_nodes$name %>%
      gsub('.*[(](C[0-9]+)[)]$', '\\1', .) %>%
      ifelse(lgraph$df_nodes$clusters, ., 'NA')

  lgraph$df_nodes$name %<>% gsub(' [(](C[0-9]+)[)]$', '', .)
  lgraph$df_links[[1]] %<>% gsub(' [(](C[0-9]+)[)]$', '', .)
  lgraph$df_links[[2]] %<>% gsub(' [(](C[0-9]+)[)]$', '', .)

  lgraph$df_links$weight %<>% scale_graph
  #lgraph$df_nodes$weight %<>% scale_graph

  lgraph$df_links %<>% setNames(c('from', 'to', 'weight'))
  lgraph$df_links = lgraph %$%                                                        
      highlight_multiple_connected(df_links, NULL)       

  lgraph$df_links %<>% convert_to_spring_weights

# lgraph$df_links %<>% setNames(c('from', 'to', 'weight'))
# lgraph$df_links = lgraph %$%                                                        
#    sgraph::highlight_multiple_connected(df_links, c('suicidal behavior',
#                                                     'suicide'))       
                                                                              
  lgraph$df_nodes$desc = lgraph$df_nodes$cui
  lgraph$df_nodes %<>% multiline_labels('display val str')                  


  igraph = l_graph_to_igraph(lgraph)

  color_map = data.frame(group = c(TRUE, FALSE),
                         color = c('#0000ff', '#ffff00'))
  sgraph = sgraph_clusters(igraph, node_size = 7,
                           color_map = color_map, label_color = 'ff0000',
                           label = c('name', `CUI: ` = 'cui'))

  # test edge size, seems size below 1 have no impact
  sgraph %<>% add_edge_size(one_size = 5)
  
  # test edge color
  sgraph %<>% add_edge_color(one_color = "#ccc")

  # add listener
  sgraph %<>% add_listener('clickNode')


  gt_legend = get_legend(color_map,
                         unique(color_map$group))




  expect_true(TRUE)
}
test_that('shiny_app', test_shiny_app())


