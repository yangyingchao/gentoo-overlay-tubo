# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit multilib-build

DESCRIPTION="The Scala Programming Language"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"

RDEPEND="|| (
        dev-lang/scala-bin
        dev-lang/scala
    )"
