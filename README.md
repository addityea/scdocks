# SCDOCKS #

Custom Docker images for addityea/scdownstream pipeline forked from nf-core/scdownstream.

## singler

Holds the requirements to run the `CELLTYPES_SINGLER` module of the pipeline.

**Major packages:**

| Package    | Version    |
|------------|------------|
| R          | 4.4.1      |
| Seurat     | 5.3.0      |
| SeuratDisk | 0.0.0.9021 |
| SingleR    | 2.8.0      |
| celldex    | 1.16.0     |
| ggplot2    | 3.5.2      |
| schard     | 0.0.1      |
| yaml       | 2.3.10     |

*The `Conda` version of `Seurat` is updated by the version in `Bioconductor` when installing `SeuratDisk`, but it's retained in `Conda` installation to address the dependencies.*
