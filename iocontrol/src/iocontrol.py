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

from configobj import ConfigObj


def get_devices(filename='/etc/siddio-iocontrol.conf'):
    '''
    Loads the configuration and returns a list of tuples in
    the form of (pin, initial_state, description).
    '''

    config = ConfigObj(filename)
    return [(int(i['pin']),bool(i['default']), i['description']) for i in config.values()]

