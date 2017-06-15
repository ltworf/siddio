#!/usr/bin/python3
# Siddio
# Copyright (C) 2017 Salvo "LtWorf" Tomaselli
#
# Siddio is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# author Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>

all:
	echo "Nothing to do"

install:
	install -D setprofile $${DESTDIR:-/}/usr/bin/setprofile
	install -D -m644 setprofile.bash $${DESTDIR:-/}/usr/share/bash-completion/completions/setprofile
	install -D -m644 setprofile.conf $${DESTDIR:-/}/etc/siddio/setprofile.conf
	install -D -m644 setprofile.1 $${DESTDIR:-/}/usr/share/man/man1/setprofile.1
	install -D -m644 setprofile.conf.5 $${DESTDIR:-/}/usr/share/man/man5/setprofile.conf.5
