
FROM rocker/shiny:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgeos-dev \
    libglpk-dev \
    libgit2-dev \
    build-essential \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /srv/shiny-server/test_shiny
WORKDIR /srv/shiny-server/test_shiny

COPY . /srv/shiny-server/test_shiny

# Install the puduapp package (required for system.file() to work in global.R)
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_local('/srv/shiny-server/test_shiny', upgrade='never', force=TRUE)"

EXPOSE 3838

# Run using the installed package
CMD ["R", "-e", "cat('Starting Shiny app...\\n'); app_dir <- system.file('app', package='puduapp'); cat('App dir:', app_dir, '\\n'); if(app_dir == '') stop('Package not installed'); shiny::runApp(app_dir, host='0.0.0.0', port=3838, launch.browser=FALSE)"]
