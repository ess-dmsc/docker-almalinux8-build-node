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
        bzip2-devel \
        cmake \
        clang-analyzer \
        cppcheck \
        doxygen \
        gcc-toolset-12 \
        git \
        graphviz \
        libffi-devel \
        make \
        ninja-build \
        patch \
        openssl-devel \
        perl-Digest-SHA \
        perl-IPC-Cmd \
        python3.11-devel \
        qt5-qtbase-devel \
        readline-devel \
        sqlite-devel \
        valgrind \
        xz-devel \
        zlib-devel && \
    dnf -y autoremove && \
    dnf clean all

RUN python3.11 -m pip install \
      conan==1.58.0 \
      coverage==4.4.2 \
      flake8==3.5.0 \
      gcovr==4.1 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

RUN git clone http://github.com/ess-dmsc/conan-configuration.git && \
    cd conan-configuration && \
    git checkout 97569ca8ba0bfdc073f8ffb6f821ce3e7e644c61 && \
    cd .. && \
    conan config install conan-configuration

COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN git clone https://github.com/linux-test-project/lcov.git && \
    cd lcov && \
    git checkout v1.14 && \
    /usr/bin/scl enable gcc-toolset-12 -- make install

RUN adduser jenkins
RUN chown -R jenkins $CONAN_USER_HOME/.conan
RUN conan config set general.revisions_enabled=True

USER jenkins

COPY files/install_pyenv.sh /home/jenkins/install_pyenv.sh

RUN bash /home/jenkins/install_pyenv.sh && \
    rm /home/jenkins/install_pyenv.sh

ENV PYENV_ROOT="/home/jenkins/.pyenv"
ENV PATH="${PATH}:$PYENV_ROOT/bin"

RUN pyenv install 3.11

WORKDIR /home/jenkins
