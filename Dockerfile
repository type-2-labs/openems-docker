# openEMS (FDTD electromagnetics: antennas, RF) with its Python interface, headless.
FROM ubuntu:24.04

ARG OPENEMS_VERSION=v0.37.0
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        git ca-certificates python3 python3-venv python3-dev openssh-server rsync wget \
        build-essential cmake libhdf5-dev libtinyxml-dev libboost-all-dev libcgal-dev libvtk9-dev \
        python3-pip python3-setuptools python3-setuptools-scm cython3 python3-numpy python3-h5py python3-matplotlib \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --recursive --depth 1 --branch ${OPENEMS_VERSION} --shallow-submodules \
        https://github.com/thliebig/openEMS-Project.git /tmp/openEMS-Project \
    && cd /tmp/openEMS-Project \
    # dependencies above are the list scripts/install_deps.sh --check --python --disable-gui asks for (v0.37.0)
    && ./update_openEMS.sh /opt/openEMS --python --disable-GUI \
    && rm -rf /tmp/openEMS-Project

ENV PATH=/opt/openEMS/bin:/opt/openEMS/venv/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/openEMS/lib:${LD_LIBRARY_PATH}
RUN python -c "import CSXCAD, openEMS; print('openEMS python OK')"

WORKDIR /workspace
