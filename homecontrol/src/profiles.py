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
import collections

from configobj import ConfigObj
from relational.relation import Relation, Header
from relational.parser import parse

import devices


_profiles = {}


def load_profiles(filename):
    '''
    loads or reloads the profiles from configuration file
    '''
    profiles_conf = ConfigObj(filename)
    _profiles.clear()
    for name in profiles_conf:
        profile = profiles_conf[name]
        _profiles[name] = Profile(name, profile['on'], profile['off'])


def get_profile(name):
    return _profiles[name]


def get_profiles():
    return _profiles.keys()


def get_relations():
    '''
    Returns dev_rel, tag_rel, dev_dic

    dev_rel relation of the devices.
    tag_rel relation of the tags
    dev_dic id: device object
    '''

    # Obtain devices and cache that stuff
    if not hasattr(get_relations, 'devs'):
        get_relations.devs = devices.devices()
        get_relations.native_properties = set(devices.Device._fields)

        properties = set(devices.Device._fields)
        for dev in get_relations.devs:
            properties.update(set(dev.properties.keys()))
        properties.difference_update({'tags'})
        properties.update({'state', 'id'})
        get_relations.properties = properties

    devs = get_relations.devs
    native_properties = get_relations.native_properties
    properties = get_relations.properties

    # Set the properties that devices have
    dev_rel = Relation()
    dev_rel.header = Header(properties)

    dev_dic = {}

    # Add the devices inside the relation
    for dev in devs:
        # Create the tuple for the device
        dev_dic[str(id(dev))] = dev
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


class Profile(collections.namedtuple('profile', ('name', 'onquery', 'offquery'))):
    def activate(self):
        rels, tags, dev_dict = get_relations()
        context = {'devices': rels, 'tags': tags}

        expr_on = parse(self.onquery)
        expr_off = parse(self.offquery)
        rel_devs_on = expr_on(context)
        rel_devs_off = expr_off(context)

        # Allow overlapping queries
        if len(rel_devs_off.intersection(rel_devs_on)):
            print("warning, they intersect")
            rel_devs_off = rel_devs_off.difference(rel_devs_on)

        id_index = rel_devs_on.header.index('id')
        for dev in rel_devs_on:
            dev_dict[dev[id_index]].switch(True)
        id_index = rel_devs_off.header.index('id')
        for dev in rel_devs_off:
            dev_dict[dev[id_index]].switch(False)
