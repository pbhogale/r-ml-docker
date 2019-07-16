FROM rocker/verse:3.5.0

RUN echo "deb http://http.debian.net/debian/ stretch main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://http.debian.net/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update -qq && apt-get install -y apt-utils
RUN apt-get update -qq && apt-get install -y \
      libssl-dev \
      libcurl4-gnutls-dev \
      libxml2-dev \
      zlib1g-dev \
      libc6-dev \
      libjpeg-dev \
      gnupg \
      gnupg1 \
      gnupg2 \
      curl

RUN R -e "install.packages(c('ranger','rstan'))" && \
	R -e "install.packages(c('haven','plumber','classInt','tidyverse','ggplot2','httr','jsonlite','openssl','Rook', 'xgboost','devtools','caret','lme4','ggthemes','testthat','e1071','forcats','Matrix','knitr','rmarkdown','mice','glmnet', 'elasticnet','brms','chron','odbc','DBI','dbplyr','dbplot','tidypredict', 'janitor','plotly','config', 'RCurl', 'rjson'))" && \
      R -e "install.packages(c('statmod', 'survival', 'stats', 'tools', 'utils', 'methods'))" && \
      R -e "install.packages('h2o', type='source', repos='http://h2o-release.s3.amazonaws.com/h2o/rel-yates/5/R')"

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -&& \
	curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN exit && \
	apt-get update && ACCEPT_EULA=Y apt-get install msodbcsql17 && \
	ACCEPT_EULA=Y apt-get install mssql-tools && \
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
	source ~/.bashrc && \
	apt-get install unixodbc-dev && \
	apt-get install fonts-firacode

RUN mkdir /home/rstudio/Documents
