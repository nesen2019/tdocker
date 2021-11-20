FROM ubuntu:20.04

LABEL org.opencontainers.image.source=https://github.com/nesen2019/tdocker

# Install basics
#RUN apt-get -y install cmake
RUN apt-get update -y \
&& apt-get install -y cmake \
&& apt-get install -y apt-utils git curl ca-certificates bzip2 \
&& apt-get install -y tree htop bmon iotop g++ \
&& apt-get install -y wget vim


# can be to use opencv
RUN apt-get -y install lib32z1 libglib2.0-dev \
    libsm6 libxrender1 libxext6 libice6 libxt6 libfontconfig1 libcups2 libgl1-mesa-glx



RUN cd ~/ \
&& wget -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh -O ~/miniconda.sh \
&& bash ~/miniconda.sh -b -p /miniconda \
&& rm -rf ~/miniconda.sh

ENV PATH=/miniconda/bin:$PATH


# set conda image
## https://blog.csdn.net/weixin_43667077/article/details/106521015
RUN echo "channels:" > ~/.condarc \
&& echo "  - defaults" >> ~/.condarc \
&& echo "show_channel_urls: true" >> ~/.condarc \
&& echo "channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda" >> ~/.condarc \
&& echo "default_channels:" >> ~/.condarc \
&& echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main" >> ~/.condarc \
&& echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free" >> ~/.condarc \
&& echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r" >> ~/.condarc \
&& echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro" >> ~/.condarc \
&& echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2" >> ~/.condarc \
&& echo "custom_channels:" >> ~/.condarc \
&& echo "  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc \
&& echo "  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc \
&& echo "  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc \
&& echo "  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc \
&& echo "  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc \
&& echo "  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> ~/.condarc \
# set pip image
## https://www.jianshu.com/p/e2dd167d2892
&& mkdir ~/.pip \
&& echo "[global]" > ~/.pip/pip.conf \
&& echo "index-url = https://mirrors.aliyun.com/pypi/simple" >> ~/.pip/pip.conf \
&& echo "[install]" >> ~/.pip/pip.conf \
&& echo "trusted-host=mirrors.aliyun.com" >> ~/.pip/pip.conf


RUN pip install ipython numpy pandas matplotlib \
&& pip install jupyter notebook\
&& pip install jupyterlab



RUN jupyter notebook --generate-config \
&& mkdir ~/progs \
&& echo "from notebook.auth import passwd" >> ~/.jupyter/jupyter_notebook_config.py \
&& echo "c.NotebookApp.ip=\"*\"" >> ~/.jupyter/jupyter_notebook_config.py \
&& echo "c.NotebookApp.password=passwd(\"000\", algorithm=\"sha1\")" >> ~/.jupyter/jupyter_notebook_config.py \
&& echo "c.NotebookApp.open_browser=False" >> ~/.jupyter/jupyter_notebook_config.py \
&& echo "c.NotebookApp.port=8888" >> ~/.jupyter/jupyter_notebook_config.py \
&& echo "c.NotebookApp.allow_root=True" >> ~/.jupyter/jupyter_notebook_config.py
#&& echo c.NotebookApp.notebook_dir=\'~/progs\' >> ~/.jupyter/jupyter_notebook_config.py


ENTRYPOINT ["sh", "-c", "jupyter notebook -y --allow-root --notebook-dir ~/progs"]

# Add Entrypoint script
# ADD start.sh /start.sh

# ENTRYPOINT [ "/start.sh" ]

