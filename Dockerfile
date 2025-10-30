FROM andy5995/slackware-build-essential:15.0
USER root
ENV USER=root
ENV SBO_HOME=/usr/sbo
ENV PKG_DIR=/packages
RUN echo "https://mirrors.ocf.berkeley.edu/slackware/slackware64-15.0/" > /etc/slackpkg/mirrors
RUN echo y | slackpkg update
RUN update-ca-certificates --fresh
# Install sbotools from tarball
RUN cd /tmp && wget https://slackware.halpanet.org/slackdce/packages/15.0/x86_64/system/sbotools/sbotools-4.0-noarch-1_slackdce.txz && upgradepkg --install-new *.txz && rm -rf /tmp/*
# Configure sbotools (use 75% of cores, minimum 1)
RUN mkdir -p /etc/sbotools && \
    echo "PKG_DIR=/packages" >> /etc/sbotools/sbotools.conf && \
    echo "DISTCLEAN=TRUE" >> /etc/sbotools/sbotools.conf && \
    echo "NOCLEAN=TRUE" >> /etc/sbotools/sbotools.conf && \
    JOBS=$(( $(nproc) * 3 / 4 )) && \
    [ "$JOBS" -lt 1 ] && JOBS=1 || true && \
    sboconfig --jobs $JOBS
# Fetch the SlackBuilds repo initially (speeds up first run)
RUN sbosnap fetch
# Create sbobuild script (updates repo, then builds all packages in one command)
RUN echo '#!/bin/bash' > /usr/local/bin/sbobuild && \
    echo 'echo "Updating SlackBuilds repository..."' >> /usr/local/bin/sbobuild && \
    echo 'sbosnap update' >> /usr/local/bin/sbobuild && \
    echo 'JOBS=$(( $(nproc) * 3 / 4 ))' >> /usr/local/bin/sbobuild && \
    echo '[ "$JOBS" -lt 1 ] && JOBS=1' >> /usr/local/bin/sbobuild && \
    echo 'sboinstall -d TRUE -j $JOBS "$@"' >> /usr/local/bin/sbobuild && \
    chmod +x /usr/local/bin/sbobuild
ENTRYPOINT ["sbobuild"]
