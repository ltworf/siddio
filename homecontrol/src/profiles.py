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

from relational.relation import Relation, Header
from relational.parser import parse

import devices

def get_relations():
    '''
    Returns dev_rel, tag_rel, dev_dic

    dev_rel relation of the devices.
    tag_rel relation of the tags
    dev_dic id: device object
    '''

    devs = devices.devices()

    native_properties = set(devices.Device._fields)
    properties = set(devices.Device._fields)

    dev_rel = Relation()

    # Set the properties that devices have
    properties.difference_update({'tags'})
    properties.update({'state', 'id'})
    dev_rel.header = Header(properties)

    dev_dic = {}

    # Add the devices inside the relation
    for dev in devs:
        # Create the tuple for the device
        dev_dic[id(dev)] = dev
        attrs = []
        for prop in dev_rel.header:
            if prop == 'tags':
                continue
            elif prop == 'state':
                attrs.append('on' if dev.get_state() else 'off')
            elif prop == 'id':
                attrs.append(id(dev))
            elif prop in native_properties:
                attrs.append(getattr(dev, prop))
            else:
                attrs.append(dev.properties.get(prop, ''))
        dev_rel.insert(attrs)

    tag_rel = Relation()
    tag_rel.header = Header(('id', 'tag'))

    for dev in devs:
        for tag in dev.tags:
            if ':' in tag:
                continue
            tag_rel.insert((id(dev), tag))

    return dev_rel, tag_rel, dev_dic
