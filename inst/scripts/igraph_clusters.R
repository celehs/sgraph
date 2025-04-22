

igraph_clusters = function(l_graph, largest_connected = TRUE, min_degree = 0,
  max_nodes = 1500) {

  igraph = igraph::graph_from_data_frame(l_graph$df_links)

  # remove isolated nodes
  if (min_degree > 0) {
    igraph %<>% igraph::delete_vertices(
      which(igraph::centralization.degree(.)$res < min_degree))
  }

  # remove using modularity
  if (length(igraph::V(igraph)) > max_nodes) {
    metric = igraph::cluster_walktrap(igraph)$modularity
    threshold = sort(metric, decreasing = TRUE)[max_nodes]
    igraph %<>% igraph::delete_vertices(which(metric < threshold))
  }

  # keep only largest connected graph
  if (largest_connected) {
    igraph %<>% igraph::components() %$%
      which(membership != which.max(csize)) %>% names %>%
      igraph::delete_vertices(igraph, .)
  }

  igraph %<>% igraph::simplify()

  if ('df_nodes' %in% names(l_graph)) {
      igraph %<>% add_igraph_info(l_graph$df_nodes)
  }

  igraph
}

