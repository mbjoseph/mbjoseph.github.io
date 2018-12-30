FROM rocker/geospatial:latest

MAINTAINER Max Joseph maxwell.b.joseph@colorado.edu

# rstan installation taken from jrnold/rstan
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	  imagemagick \
	  jags \
	  ffmpeg \
	  xauth \
	  xfonts-base \
	  xvfb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

RUN TEMP_DEB="$(mktemp)" \
  && wget -O "$TEMP_DEB" 'https://github.com/jgm/pandoc/releases/download/2.5/pandoc-2.5-1-amd64.deb' \
  && dpkg -i "$TEMP_DEB" \
  && rm -f "$TEMP_DEB"

# Global site-wide config -- neeeded for building packages
RUN mkdir -p $HOME/.R/ \
  && echo "CXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -flto -ffat-lto-objects  -Wno-unused-local-typedefs \n" >> $HOME/.R/Makevars

# Config for rstudio user
RUN mkdir -p $HOME/.R/ \
  && echo "CXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -flto -ffat-lto-objects  -Wno-unused-local-typedefs -Wno-ignored-attributes -Wno-deprecated-declarations\n" >> $HOME/.R/Makevars \
  && echo "options(mc.cores = parallel::detectCores())\n" >> /home/rstudio/.Rprofile

WORKDIR /home/rstudio

COPY DESCRIPTION ./DESCRIPTION

RUN xvfb-run Rscript -e 'deps <- devtools::dev_package_deps(dependencies = NA);devtools::install_deps(dependencies = TRUE);if (!all(deps$package %in% installed.packages())) { message("missing: ", paste(setdiff(deps$package, installed.packages()), collapse=", ")); q(status = 1, save = "no")}'
