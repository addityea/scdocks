FROM ubuntu:latest

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    gdebi-core \
    libcurl4-openssl-dev \
    libssl-dev \
    libz-dev \
    libxml2-dev \
    sudo \
    pandoc \
    libclang-dev \
    libedit2 \
    libsqlite3-dev \
    procps \
    tzdata \
    poppler-utils \
    libhdf5-dev \
    automake \
    patch
# Set timezone and locale
ENV TZ=Europe/Stockholm
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Install Conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /aditya/miniconda3
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH="/aditya/miniconda3/bin:${PATH}"

# Install conda packages using the conda.yaml file
COPY conda.yml .
RUN conda env create -f conda.yml --name singler
RUN echo "source activate singler" > ~/.bashrc
ENV PATH="/aditya/miniconda3/envs/singler/bin:${PATH}"

# Set R to use Conda-installed R
ENV R_HOME="/aditya/miniconda3/envs/singler/lib/R"
ENV R_LIBS="/aditya/miniconda3/envs/singler/lib/R/library"

# Set CRAN and Bioconductor repos
RUN echo 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/noble/latest"))' >> /root/.Rprofile
RUN echo 'options(BioC_mirror = "https://packagemanager.posit.co/bioconductor/latest")' >> /root/.Rprofile && \
  echo 'options(BIOCONDUCTOR_CONFIG_FILE = "https://packagemanager.posit.co/bioconductor/latest/config.yaml")' >> /root/.Rprofile && \
  echo 'Sys.setenv("R_BIOC_VERSION" = "3.20")' >> /root/.Rprofile

RUN R -e 'BiocManager::install("rhdf5"); library(rhdf5)'
RUN R -e 'BiocManager::install("rhdf5filters"); library(rhdf5filters)'
#RUN R -e 'devtools::install_github("cellgeni/schard"); library(schard)'

RUN R -e 'pak::pak("scverse/anndataR", dependencies = TRUE)'

