# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class bigtop_toolchain::jdk {
  case $::operatingsystem {
    /Debian/: {
      include apt

      package { 'jdk8' :
        name => 'temurin-8-jdk',
        ensure => present,
      }
    }
    /Ubuntu/: {
      include apt

      package { 'jdk8' :
        name => 'openjdk-8-jdk',
        ensure  => present,
      }
    }
    /(CentOS|Amazon|Fedora|RedHat|Rocky|openEuler)/: {
      package { 'jdk8' :
        name => 'java-1.8.0-openjdk-devel',
        ensure => present
      }

      if ($::operatingsystem == "Fedora") {
        file { '/usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/cacerts':
          ensure => 'link',
          target => '/etc/pki/java/cacerts'
        }
      }
    }
    /OpenSuSE/: {
      package { 'jdk8' :
        name => 'java-1_8_0-openjdk-devel',
        ensure => present
      }
    }
  }

  case $::operatingsystem {
    /Debian/: {
      exec { 'ensure java 8 is set as default':
        command => "update-java-alternatives --set temurin-8*",
        path    => ['/usr/sbin', '/usr/bin', '/bin'],
        require => Package['jdk8'],
      }
    }
    /Ubuntu/: {
      exec { 'ensure java 8 is set as default':
        command => "update-java-alternatives --set java-1.8.0-openjdk-$(dpkg --print-architecture)",
        path    => ['/usr/sbin', '/usr/bin', '/bin'],
        require => Package['jdk8'],
      }
    }
    /(CentOS|RedHat|Rocky)/: {
      exec { 'ensure java 8 is set as default':
        command => "update-alternatives --set java java-1.8.0-openjdk.$(uname -m) \
                    && update-alternatives --set javac java-1.8.0-openjdk.$(uname -m)",
        path    => ['/usr/sbin', '/usr/bin', '/bin'],
        require => Package['jdk8'],
      }
    }
    /Fedora/: {
      exec { 'ensure java 8 is set as default':
        command => "update-alternatives --set java /usr/lib/jvm/java-1.8.0-openjdk/jre/bin/java \
                    && update-alternatives --set javac /usr/lib/jvm/java-1.8.0-openjdk/bin/javac",
        path    => ['/usr/sbin', '/usr/bin', '/bin'],
        require => Package['jdk8'],
      }
    }
  }
}
