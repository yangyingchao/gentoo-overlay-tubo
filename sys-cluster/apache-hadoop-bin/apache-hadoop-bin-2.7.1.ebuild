# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

MY_PN="hadoop"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Software framework for data intensive distributed applications"
HOMEPAGE="http://hadoop.apache.org/"
SRC_URI="mirror://apache/hadoop/common/${MY_P}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"

DEPEND=""
RDEPEND="virtual/jre
net-misc/openssh"

S=${WORKDIR}/${MY_P}
INSTALL_DIR=/opt/${MY_P}

pkg_setup() {
    if [ $EUID -eq 0 ]; then
	    enewgroup hadoop
    fi
}

src_install() {
	# get the cluster topology from /etc/hosts
	hostname=`uname -n`
	namenode=`egrep "^[0-9].*#.* namenode" /etc/hosts | awk '{print $2}' `
	[[ -n $namenode ]] || namenode=$hostname
	secondary=`egrep "^[0-9].*#.* secondaryname" /etc/hosts | awk '{print $2}'`
	[[ -n $secondary ]] || secondary=$hostname
	resmgr=`egrep "^[0-9].*#.* resourcemanager" /etc/hosts | awk '{print $2}'`
	[[ -n $resmgr ]] || resmgr=$hostname
	histsrv=`egrep "^[0-9].*#.* historyserver" /etc/hosts | awk '{print $2}'`
	[[ -n $histsrv ]] || histsrv=$hostname

	sandbox=`egrep -c "^[0-9].*#.* sandbox" /etc/hosts`
	replication=`egrep -c "^[0-9].*#.* datanode" /etc/hosts`
	[ $replication -gt 3 ] && replication=3
	if [ $replication -eq 0 ]; then
        replication=1
		# if [ $sandbox -ne 0 ]; then
		# 	replication=1
		# else
        #     replication=3
		# fi
	fi
	javaheap=1024
	[ $sandbox -ne 0 ] && javaheap=192

	# hadoop-env.sh
	cat >tmpfile<<EOF
export JAVA_HOME=$(java-config -g JAVA_HOME)
export HADOOP_PID_DIR=${EPREFIX}/var/log/hadoop
export HADOOP_LOG_DIR=${EPREFIX}/var/log/hadoop
export HADOOP_HEAPSIZE=$javaheap
EOF
	sed -i '/# Set Hadoop-specific/r tmpfile' etc/hadoop/hadoop-env.sh || die

	# yarn-env.sh
	cat >tmpfile<<EOF
export JAVA_HOME=$(java-config -g JAVA_HOME)
export YARN_CONF_DIR=${EPREFIX}/etc/hadoop
export YARN_LOG_DIR=${EPREFIX}/var/log/hadoop
export YARN_PID_DIR=${EPREFIX}/var/log/hadoop
export YARN_HEAPSIZE=$javaheap
EOF
	sed -i "/# limitations under the/r tmpfile"  etc/hadoop/yarn-env.sh || die

	# mapred-env.sh
	cat >tmpfile<<EOF
export JAVA_HOME=$(java-config -g JAVA_HOME)
export HADOOP_MAPRED_LOG_DIR=${EPREFIX}/var/log/hadoop
export HADOOP_MAPRED_PID_DIR=${EPREFIX}/var/log/hadoop
export HADOOP_JOB_HISTORYSERVER_HEAPSIZE=$javaheap
EOF
	cat tmpfile >>etc/hadoop/mapred-env.sh || die

	# core-site.xml
	cat >tmpfile<<EOF
<property>
  <name>fs.defaultFS</name>
  <value>hdfs://$namenode</value>
</property>
EOF
	sed -i '/<configuration>/r tmpfile' etc/hadoop/core-site.xml || die
	# hdfs-site.xml
	cat >tmpfile<<EOF
<property>
  <name>dfs.namenode.name.dir</name>
  <value>file:${EPREFIX}/var/lib/hdfs/name</value>
</property>
<property>
  <name>dfs.datanode.data.dir</name>
  <value>file:${EPREFIX}/var/lib/hdfs/data</value>
</property>
<property>
  <name>dfs.namenode.secondary.http-address</name>
  <value>hdfs://${secondary}:50090</value>
</property>
<property>
  <name>dfs.replication</name>
  <value>$replication</value>
</property>
EOF
	if [ $sandbox -ne 0 ] ; then cat >>tmpfile<<EOF
<property>
  <name>dfs.blocksize</name>
  <value>10M</value>
</property>
EOF
	fi
	sed -i '/<configuration>/r tmpfile' etc/hadoop/hdfs-site.xml ||die

	# yarn-site.xml
	cat >tmpfile<<EOF
<property>
  <name>yarn.nodemanager.aux-services</name>
  <value>mapreduce_shuffle</value>
</property>
<property>
  <name>yarn.resourcemanager.hostname</name>
  <value>$resmgr</value>
</property>
EOF
	if [ $sandbox -ne 0 ] ; then cat >>tmpfile<<EOF
<property>
  <name>yarn.nodemanager.resource.memory-mb</name>
  <value>384</value>
</property>
<property>
  <name>yarn.nodemanager.resource.cpu-vcores</name>
  <value>1</value>
</property>
<property>
  <name>yarn.scheduler.minimum-allocation-mb</name>
  <value>192</value>
</property>
<property>
  <name>yarn.scheduler.maximum-allocation-mb</name>
  <value>192</value>
</property>
<property>
  <name>yarn.nodemanager.vmem-check-enabled</name>
  <value>false</value>
</property>
EOF
	fi
	sed -i '/<configuration>/r tmpfile' etc/hadoop/yarn-site.xml || die

	# mapred-site.xml
	[ -f etc/hadoop/mapred-site.xml ] \
		|| cp etc/hadoop/mapred-site.xml.template etc/hadoop/mapred-site.xml
	cat >tmpfile<<EOF
<property>
  <name>mapreduce.framework.name</name>
  <value>yarn</value>
</property>
<property>
  <name>mapreduce.jobhistory.address</name>
  <value>$histsrv:10020</value>
</property>
EOF
	if [ $sandbox -ne 0 ] ; then cat >>tmpfile<<EOF
<property>
  <name>yarn.app.mapreduce.am.resource.mb</name>
  <value>192</value>
</property>
<property>
  <name>mapreduce.map.memory.mb</name>
  <value>192</value>
</property>
<property>
  <name>mapreduce.reduce.memory.mb</name>
  <value>192</value>
</property>
EOF
	fi
	sed -i '/<configuration>/r tmpfile' etc/hadoop/mapred-site.xml || die

	# make useful dirs
    if [ $EUID -eq 0 ]; then
	    diropts -m775 -o root -g hadoop
    fi

	dodir "${INSTALL_DIR}"
	dodir /var/log/hadoop
	dodir /var/lib/hdfs

	# install dir
	rm -f sbin/*.cmd etc/hadoop/*.cmd
	fperms g+w etc/hadoop/*
	mv "${S}"/* "${ED}${INSTALL_DIR}"

	# env file
	cat > 99hadoop <<EOF
HADOOP_HOME="${EPREFIX}/${INSTALL_DIR}"
HADOOP_YARN_HOME="${EPREFIX}/${INSTALL_DIR}"
HADOOP_MAPRED_HOME="${EPREFIX}/${INSTALL_DIR}"
PATH="${EPREFIX}/${INSTALL_DIR}/bin"
CONFIG_PROTECT="${EPREFIX}/${INSTALL_DIR}/etc/hadoop"
EOF
	doenvd 99hadoop

	# conf symlink
	dosym ${EPREFIX}/${INSTALL_DIR}/etc/hadoop /etc/hadoop

	# init scripts
	newinitd "${FILESDIR}"/hadoop.init hadoop.init
	for i in "namenode" "datanode" "secondarynamenode" "resourcemanager" "nodemanager" "historyserver"
		do if [ `egrep -c "^[0-9].*#.*namenode" /etc/hosts` -eq 0 ] || [ `egrep -c "^[0-9].*${hostname}.*#.* ${i}" /etc/hosts` -eq 1 ] ; then
	   dosym  ${EPREFIX}/etc/init.d/hadoop.init /etc/init.d/hadoop-"${i}"
	   fi
	done

	# opt synlink
	dosym "${EPREFIX}/${INSTALL_DIR}" "/opt/${MY_PN}"
}

pkg_postinst() {
	elog ""
	elog "You must be in the hadoop group to use apache-hadoop."
	elog ""
	elog "Systemd is not supported for now, and you have to start/stop hadoop manually"
	elog "by executing scripts in: ${INSTALL_DIR}/sbin/"
	elog ""
}
