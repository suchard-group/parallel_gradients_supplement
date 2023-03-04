[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7697475.svg)](https://doi.org/10.5281/zenodo.7697475)

# Many-core algorithms for high-dimensional gradients on phylogenetic trees
This repository contains the scripts and XML files required to reproduce the analyses performed in the "Many-core algorithms for high-dimensional gradients on phylogenetic trees" paper by Gangavarapu et al.

We provide Docker images to run BEAGLE on Nvidia devices using CUDA 10.1 and CUDA 11.6. 
You will need to use the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/overview.html) to run these images. 
For AMD devices, we suggest installing BEAST and BEAGLE locally as described in `Local installation`.  

Please note that we have only included the XMLs for the carnivores and Dengue dataset in this repository, 

```
Dengue997_s3_codon_hmc.xml
Dengue997_s3_nuc_hmc.xml
carnivores_codon_hmc.xml
carnivores_nuc_hmc.xml
```

The following large XMLs for the yeast dataset have been deposited on Zenodo, available at this [link](https://doi.org/10.5281/zenodo.7697474).

```
yeast_codon_hmc_122.xml
yeast_codon_hmc_61.xml
yeast_nuc_hmc.xml
```

The log files used for the benchmarks in the paper and the tree files for the West Nile virus analysis have also been deposited on Zenodo, available at this [link](https://doi.org/10.5281/zenodo.7697474). 

### Running within Docker image

```
git clone https://github.com/suchard-group/parallel_gradients_supplement.git
docker build -t beast-beagle:parallel_gradients .
docker run -v $(pwd):/data --gpus all -it -v $(pwd):/data beast-beagle:parallel_gradients /bin/bash

# In the interactive bash session within docker container
cd /data/
./run.sh
```

The commands above will create log files with the total wall time and individual BEAGLE function times under `benchmarks/results/`.  

### Local installation 

```
# Install BEAGLE with required flags to perform benchmarks 
git clone -b hmc-clock https://github.com/beagle-dev/beagle-lib.git
cd beagle-lib
git checkout 31b4d9ef2b08f8af187f985f3a10e2844ff7d775
mkdir build
cd build
cmake -DBUILD_OPENCL=OFF -DBEAGLE_BENCHMARK=ON -DBEAGLE_DEBUG_SYNCH=ON .. && \
make install && \
apt-get autoremove && apt-get autoclean && \
echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
```

The libraries are installed into `/usr/local/lib`. 
You can find them using `ls /usr/local/lib/*beagle*`.
You can add `-DCMAKE_INSTALL_PREFIX` to `cmake` and specify an alternate location to install BEAGLE.

```
# Install BEAST
git clone -b sars-cov-2-origins https://github.com/beast-dev/beast-mcmc.git && \
cd beast-mcmc && \
ant
```

Clone this repository using,
```
git clone https://github.com/suchard-group/parallel_gradients_supplement.git
```

Edit BEAST_HOME on line 11 of [benchmark.sh](benchmark.sh#L11) to point to the `beast-mcmc` directory.

```
cd parallel_gradients_supplement/
./run.sh
```

The commands above will create log files with the total wall time and individual BEAGLE function times under `benchmarks/results/`.
