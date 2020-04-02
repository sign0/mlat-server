FROM ubuntu:16.04

RUN apt-get update -y && \
  apt-get install -y python3-pip idle3 wget && \
  pip3 install --no-cache-dir --upgrade pip && \
  \
  # delete cache and tmp files
  apt-get clean && \
  apt-get autoclean && \
  rm -rf /var/cache/* && \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/* && \
  rm -rf /var/lib/apt/lists/* && \
  \
  # make some useful symlinks that are expected to exist
  cd /usr/bin && \
  ln -s idle3 idle && \
  ln -s pydoc3 pydoc && \
  ln -s python3 python && \
  ln -s python3-config python-config && \
  cd /

RUN mkdir -p /usr/local/py382 && \
  cd /usr/local/py382 && \
  wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz && \
  tar xf Python-3.8.2.tar.xz && \
  cd Python-3.8.2 && \
  CFLAGS="-march=native" ./configure && make -j4 && \
  pip3 install virtualenv pathlib2 && \
  hash -r && \
  rm -rf /usr/local/py382/venv && \
  virtualenv -p /usr/local/py382/Python-3.8.2/python /usr/local/py382/venv && \
  /bin/bash -c "source /usr/local/py382/venv/bin/activate" && \
  pip3 install numpy scipy pykalman python-graph-core

COPY . /mlat-server/

RUN /bin/bash -c "source /usr/local/py382/venv/bin/activate"

RUN cd /mlat-server && \
  python3 mlat-server --help
