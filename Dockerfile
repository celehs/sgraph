
from rocker/shiny-verse:4.4.1
run apt-get update && \
  apt-get install -y --no-install-recommends texlive texlive-latex-recommended texlive-fonts-extra qpdf && \
  apt-get install -y libxml2-dev libglpk-dev

run R -e "install.packages(c('flexdashboard', 'igraph', 'jsonlite', 'RColorBrewer'))"
run R -e "install.packages('cowplot')"

run apt-get update && apt-get install -y tidy

run R -e "install.packages('shinyBS')"

run R -e "install.packages('covr')"

run apt-get update && apt-get install -y git

add ./ /sgraph
run R -e "devtools::install('sgraph', dependencies = TRUE)"
