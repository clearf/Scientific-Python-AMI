
# OS related packages
#sudo apt-get update
sudo yum install curl vim
sudo yum  install zlib-devel 



# XXX Not 100% sure that these are the right lapack libraries
sudo yum install lapack64.x86_64 lapack64-devel.x86_64
# sudo apt-get install liblapack-dev
sudo yum install gcc gcc-c++
sudo yum install gcc-gfortran.noarch

sudo yum install openmpi-devel
sudo yum install boost-openmpi-devel

# Install pip3 and update improtant packages
#sudo apt-get install python3-pip python3-dev
#sudo pip3 install -U setuptools
#sudo pip3 install -U pip

# Install packages needed to compile numpy
sudo pip install cython
sudo pip install nose

# OpenBLAS
git clone git://github.com/xianyi/OpenBLAS
pushd OpenBLAS
make FC=gfortran
sudo make PREFIX=/usr/local/ install
popd
rm -rf OpenBLAS
 
# Numpy
# sudo pip uninstall numpy
git clone https://github.com/numpy/numpy
pushd numpy
cat > site.cfg << EOL
[default]
library_dirs = /usr/local/lib

[atlas]
atlas_libs = openblas
library_dirs = /usr/local/lib

[lapack]
lapack_libs = openblas
library_dirs = /usr/local/lib

EOL
export BLAS=/usr/local/lib/libopenblas.a
export LAPACK=/usr/local/lib/libopenblas.a
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/
echo 'export BLAS=/usr/local/lib/libopenblas.a' >>~/.bash_profile
echo 'LAPACK=/usr/local/lib/libopenblas.a' >>~/.bash_profile
echo 'LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/' >>~/.bash_profile
python setup.py build
# verify existence of build/lib.*/numpy/core/_dotblas.so
#run test_numpy.py
sudo python setup.py install
popd
#rm -rf numpy

# Scipy
git clone https://github.com/scipy/scipy
pushd scipy
python setup.py build
sudo BLAS=/usr/local/lib/libopenblas.a LAPACK=/usr/local/lib/libopenblas.a LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/ python setup.py install
# run test_scipy.py
popd
#rm -rf scipy


# szip (for hdf5)
wget http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz
tar -zxvf szip-2.1.tar.gz
pushd szip-2.1
./configure --prefix=/usr/local
make
sudo make install
popd 



wget http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.15-patch1.tar.gz
pushd hdf5-1.8.15-patch1
./configure --prefix=/usr/local
make 
sudo make install
popd


# Install other important Python packages 
#sudo pip install ipython[all]
#sudo pip install greenlet
#sudo pip install scoop
#sudo pip install deap
#sudo pip install pandas
#sudo pip install tables
sudo BLAS=/usr/local/lib/libopenblas.a LAPACK=/usr/local/lib/libopenblas.a LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/ /usr/local/bin/pip install --upgrade -r ./requirements.txt

sudo BLAS=/usr/local/lib/libopenblas.a LAPACK=/usr/local/lib/libopenblas.a LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/ /usr/local/bin/pip install --install-option='--hdf5=/usr/local/lib' tables
