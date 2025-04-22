# sgraph

[![CRAN version](http://www.r-pkg.org/badges/version/sgraph)](https://cran.r-project.org/package=sgraph)
[![codecov](https://codecov.io/gl/thomaschln/sgraph/graph/badge.svg?token=UNZXB3R6P1)](https://codecov.io/gl/thomaschln/sgraph)
[![CRAN total downloads](http://cranlogs.r-pkg.org/badges/grand-total/sgraph)](https://cran.r-project.org/package=sgraph)
[![CRAN monthly downloads](http://cranlogs.r-pkg.org/badges/sgraph)](https://cran.r-project.org/package=sgraph)

R package for sigma.js v2.4.0 graph visualization. Htmlwidgets wrapper inspired by the sigmaNet package.

## Installation

Development version, using the remotes package in R:

```r
  remotes::install_git('https://gitlab.com/thomaschln/sgraph.git')
```

Stable version from CRAN, in R:

```r
  install.packages('sgraph')
```

## Usage

Build a sgraph object from an igraph object

```r
  library(igraph)
  library(sgraph)
 
  data(lesMis)
 
  sig <- sigma_from_igraph(lesMis)
  sig
```

Modify the node size of a sgraph object.

```r
 
  # one size for all nodes
  sig %>% add_node_size(one_size = 7)
 
  # using a vector
  df_nodes = cbind.data.frame(name = vertex_attr(lesMis, 'id'),
    degree = degree(lesMis))

  # seems sigma.js is not scaling automatically with min_size and max_size
  # do it manually for now
  df_nodes$degree %<>% scale(center = FALSE) %>% `*`(3) %>% `+`(3)

  igraph = add_igraph_info(lesMis, df_nodes)

  sig <- sigma_from_igraph(lesMis) %>%
   add_node_size(size_vector = vertex_attr(igraph, 'degree'), min_size = 3, max_size = 8)
  sig
```

Modify the node labels of a sgraph object.

```r
  sig %>%
    add_node_labels(label_attr = 'label')
```

Use in Shiny and Flexdashboard (see examples in shiny-server folder)

## Development status

Submitted to CRAN

## License

This package is free and open source software, licensed under GPL-3.
