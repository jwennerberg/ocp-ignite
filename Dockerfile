#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Start from a Java image.
FROM rhel7

# Ignite version
ENV IGNITE_VERSION 1.9.0
ENV IGNITE_HOME /opt/ignite/apache-ignite-fabric-${IGNITE_VERSION}-bin

USER root

RUN INSTALL_PKGS="java-1.8.0-openjdk-headless unzip wget lsof rsync tar which" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    curl -sL https://dist.apache.org/repos/dist/release/ignite/${IGNITE_VERSION}/apache-ignite-fabric-${IGNITE_VERSION}-bin.zip -o /tmp/ignite.zip && \
    unzip /tmp/ignite.zip -d /opt/ignite && \
    rm /tmp/ignite.zip && \
    chown -R 1001:0 /opt/ignite && \
    chmod -R g+w /opt/ignite

WORKDIR /opt/ignite

# Copy sh files and set permission
COPY ./run.sh $IGNITE_HOME/

RUN chmod +x $IGNITE_HOME/run.sh

USER 1001

CMD $IGNITE_HOME/run.sh

EXPOSE 11211 47100 47500 49112
