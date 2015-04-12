
cat << EOF > /etc/yum.repos.d/katello-koji.repo
[katello-koji]
name=katello-koji
baseurl=http://koji.katello.org/releases/yum/katello-nightly/katello/RHEL/7Server/x86_64/
gpgcheck=0
sslverify=0
enabled=1
EOF

cat << EOF > /etc/yum.repos.d/foreman-koji.repo
[foreman-koji]
name=foreman-koji
baseurl=http://koji.katello.org/releases/yum/foreman-nightly/RHEL/7/x86_64/
gpgcheck=0
sslverify=0
enabled=1
EOF


cat << EOF > /etc/yum.repos.d/pulp-koji.repo
[pulp-koji]
name=pulp-koji
baseurl=http://koji.katello.org/releases/yum/katello-nightly/pulp/RHEL/7Server/x86_64/
gpgcheck=0
sslverify=0
enabled=1
EOF


cat << EOF > /etc/yum.repos.d/candlepin-koji.repo
[candlepin-koji]
name=candlepin-koji
baseurl=http://koji.katello.org/releases/yum/katello-nightly/candlepin/RHEL/7Server/x86_64/
gpgcheck=0
sslverify=0
enabled=1
EOF


cat << EOF > /etc/yum.repos.d/plugins-koji.repo
[plugins-koji]
name=plugins-koji
baseurl=http://koji.katello.org/releases/yum/foreman-plugins-nightly/RHEL/7/x86_64/
gpgcheck=0
sslverify=0
enabled=1
EOF
