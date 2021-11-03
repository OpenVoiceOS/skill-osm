#!/usr/bin/env python3
from setuptools import setup

# skill_id=package_name:SkillClass
PLUGIN_ENTRY_POINT = 'skill-osm.openvoiceos=ovos_skill_osm:OSMInstallerSkill'

setup(
    # this is the package name that goes on pip
    name='ovos-skill-osm',
    version='0.0.1',
    description='OVOS osm skill plugin',
    url='https://github.com/OpenVoiceOS/skill-osm',
    author='JarbasAi',
    author_email='jarbasai@mailfence.com',
    license='Apache-2.0',
    package_dir={"ovos_skill_osm": ""},
    package_data={'ovos_skill_osm': ['vocab/*', "ui/*"]},
    packages=['ovos_skill_osm'],
    include_package_data=True,
    install_requires=["ovos-plugin-manager>=0.0.2",
                      "json_database",
                      "validators"],
    keywords='ovos skill plugin',
    entry_points={'ovos.plugin.skill': PLUGIN_ENTRY_POINT}
)
