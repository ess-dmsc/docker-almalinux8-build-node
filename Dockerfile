FROM almalinux:8

RUN dnf -y install 'dnf-command(config-manager)' && \
    dnf -y config-manager --enable powertools && \
    dnf -y install \
        jq \
        python3.11 \
        python3.11-pip && \
    dnf -y autoremove && \
    dnf clean all

RUN python3.11 -m pip install --upgrade pip && \
    python3.11 -m pip install yq && \
    rm -rf /root/.cache/pip/*

RUN dnf -y install \
        autoconf \
        automake \
        cmake \
        clang-analyzer \
        cppcheck \
        doxygen \
        gcc-toolset-12 \
        git \
        graphviz \
        make \
        ninja-build \
        patch \
        python3.11-devel \
        qt5-qtbase-devel \
        valgrind && \
    dnf -y autoremove && \
    dnf clean all

RUN python3.11 -m pip install \
      conan==1.58.0 \
      coverage==4.4.2 \
      flake8==3.5.0 \
      gcovr==4.1 && \
    rm -rf /root/.cache/pip/*
