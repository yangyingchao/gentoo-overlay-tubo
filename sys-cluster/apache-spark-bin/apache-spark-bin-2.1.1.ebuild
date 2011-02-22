# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
inherit user

MY_PN="spark"

DESCRIPTION="Software framework for fast cluster computing"
HOMEPAGE="http://spark.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${MY_PN}-${PV}/${MY_PN}-${PV}-bin-hadoop2.7.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"
IUSE="scala"

DEPEND="scala? ( virtual/scala )"

RDEPEND="virtual/jre
scala? (
virtual/scala
)"


S="${WORKDIR}/${MY_PN}-${PV}-bin-hadoop2.7"
INSTALL_DIR=/opt/${MY_PN}-${PV}

pkg_setup(){
    if [ $EUID -eq 0 ]; then
	    enewgroup hadoop
	    enewuser spark -1 /bin/bash /home/spark hadoop
    fi
}

src_install() {
	sandbox=`egrep -c "^[0-9].*#.* sandbox" /etc/hosts`
	workmem=1024m
	[ $sandbox -ne 0 ] && workmem=192m

	# create file spark-env.sh
	cat > conf/spark-env.sh <<-EOF
SPARK_LOG_DIR=${EPREFIX}/var/log/spark
SPARK_PID_DIR=${EPREFIX}/var/run/pids
SPARK_LOCAL_DIRS=${EPREFIX}/var/lib/spark
SPARK_WORKER_MEMORY=${workmem}
SPARK_WORKER_DIR=${EPREFIX}/var/lib/spark
EOF

	dodir "${INSTALL_DIR}"
    if [ $EUID -eq 0 ]; then
	    diropts -m770 -o spark -g hadoop
    fi

	dodir /var/log/spark
	dodir /var/lib/spark
	rm -f bin/*.cmd
	# dobin bin/*
	fperms g+w conf/*
	mv "${S}"/* "${ED}${INSTALL_DIR}"

    if [ $EUID -eq 0 ]; then
	    fowners -Rf root:hadoop "${INSTALL_DIR}"
    fi

	# conf symlink
	dosym ${EPREFIX}/${INSTALL_DIR}/conf /etc/spark

	cat > 99spark <<EOF
SPARK_HOME="${EPREFIX}/${INSTALL_DIR}"
SPARK_CONF_DIR="${EPREFIX}/etc/spark"
PATH="${EPREFIX}/${INSTALL_DIR}/bin"
EOF
	doenvd 99spark

	# init scripts
	newinitd "${FILESDIR}"/"${MY_PN}.init" "${MY_PN}.init"
	dosym  ${EPREFIX}/etc/init.d/"${MY_PN}.init" /etc/init.d/"${MY_PN}-worker"
	if [ `egrep -c "^[0-9].*${HOSTNAME}.*#.* sparkmaster" /etc/hosts` -eq 1 ] ; then
		dosym   ${EPREFIX}/etc/init.d/"${MY_PN}.init" /etc/init.d/"${MY_PN}-master"
	fi
	dosym  ${EPREFIX}/"${INSTALL_DIR}" "/opt/${MY_PN}"
}
