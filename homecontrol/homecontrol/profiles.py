# Siddio
# Copyright (C) 2017-2022 Salvo "LtWorf" Tomaselli
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
from syslog import *
from typing import Dict

from configobj import ConfigObj
from relational.relation import Relation, Header
from relational.parser import parse

from homecontrol import devices


_profiles = {}  # type: Dict[str,Profile]


def load_profiles(filename:str ) -> None:
    '''
    loads or reloads the profiles from configuration file
    '''
    profiles_conf = ConfigObj(filename)
    _profiles.clear()
    for name in profiles_conf:
        profile = profiles_conf[name]
        _profiles[name] = Profile(
            name,
            profile.get('on','σ False(devices)'),
            profile.get('off','σ False(devices)'),
        )


def get_profile(name: str):
    return _profiles.get(name)


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

    dev_dic = {}

    # Add the devices inside the relation
    content = set()
    for dev in devs:
        # Create the tuple for the device
        dev_dic[id(dev)] = dev
        attrs = []
        for prop in properties:
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
        content.add(tuple(attrs))
    dev_rel = Relation(Header(properties), content)

    tag_content = set()
    for dev in devs:
        for tag in dev.tags:
            if ':' in tag:
                continue
            tag_content.add((id(dev), tag))
    tag_rel = Relation(Header(('id', 'tag')), tag_content)

    return dev_rel, tag_rel, dev_dic


class Profile(collections.namedtuple('profile', ('name', 'onquery', 'offquery'))):
    def _getrels(self):
        rels, tags, dev_dict = get_relations()
        context = {'devices': rels, 'tags': tags}

        try:
            expr_on = parse(self.onquery)
        except Exception as e:
            syslog(LOG_ERR, 'Unable to parse %s %s' % (self.onquery, e))
            raise
        try:
            expr_off = parse(self.offquery)
        except Exception as e:
            syslog(LOG_ERR, 'Unable to parse %s %s' % (self.offquery, e))
            raise

        try:
            rel_devs_on = expr_on(context)
        except Exception as e:
            syslog(LOG_ERR, 'Error in running query: %s %s' % (self.onquery, e))
            raise

        try:
            rel_devs_off = expr_off(context)
        except Exception as e:
            syslog(LOG_ERR, 'Error in running query: %s %s' % (self.offquery, e))
            raise

        # Allow overlapping queries
        if len(rel_devs_off.intersection(rel_devs_on)):
            syslog(LOG_WARNING, 'Relations intersect!')
            rel_devs_off = rel_devs_off.difference(rel_devs_on)

        return dev_dict, rel_devs_on, rel_devs_off


    def is_active(self) -> bool:
        dev_dict, rel_devs_on, rel_devs_off = self._getrels()

        id_index = rel_devs_on.header.index('id')
        on = all(dev_dict[dev[id_index]].get_state() for dev in rel_devs_on)

        id_index = rel_devs_off.header.index('id')
        off = all(not dev_dict[dev[id_index]].get_state() for dev in rel_devs_off)

        return on and off


    def activate(self) -> None:
        dev_dict, rel_devs_on, rel_devs_off = self._getrels()

        id_index = rel_devs_on.header.index('id')
        for dev in rel_devs_on:
            dev_dict[dev[id_index]].switch(True)
        id_index = rel_devs_off.header.index('id')
        for dev in rel_devs_off:
            dev_dict[dev[id_index]].switch(False)
