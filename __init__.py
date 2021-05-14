from mycroft.skills.core import (MycroftSkill,
                                 intent_handler, intent_file_handler)
from mycroft.messagebus.message import Message
from ovos_skills_manager.osm import OVOSSkillsManager
from ovos_skills_manager.appstores.pling import get_pling_skills
from ovos_skills_manager.appstores.ovos import get_ovos_skills
from json_database import JsonStorage
from os.path import join, dirname, abspath

class OSMInstaller(MycroftSkill):

    def __init__(self):
        super(OSMInstaller, self).__init__(name="OSMInstaller")
        self.ovos = OVOSSkillsManager()
        self.ovos.enable_appstore("ovos")
        self.ovos.enable_appstore("pling")
        self.ovos_skills_model = []
        self.pling_skills_model = []
        self.plingDB = join(self.file_system.path, 'pling-list.db')
        self.pling_storage = JsonStorage(self.plingDB)
        
    def initialize(self):
        self.add_event("OSMInstaller.openvoiceos.home", self.handle_display_home)
    
    @intent_file_handler("show-osm.intent")
    def handle_display_home(self):
        self.log.info("todo")
        self.build_skills_model("pling")
        
    def build_skills_model(self, appstore):
        self.log.info("Bulding model for " + appstore)
        if appstore == "ovos":
            self.log.info("Selected OVOS Appstore")
            appstore_model = self.build_ovos_skills_model()
        elif appstore == "pling":
            self.log.info("Selected Pling Appstore")
            if "model" not in self.pling_storage:
                appstore_model = self.build_pling_skills_model()
                self.pling_storage["model"] = appstore_model
                self.pling_storage.store()
            
            self.gui["appstore_model"] = self.pling_storage["model"]
        else:
            print("no valid appstore found")
        
        self.log.info(appstore_model)
        self.gui.show_page("AppstoreHome.qml", override_idle=True)

    def build_ovos_skills_model(self):
        self.ovos_skills_model.clear()
        for s in get_ovos_skills(parse_github=False):
            self.ovos_skills_model.append({"title": s.skill_name, "description": s.skill_description, "icon": s.skill_icon, "author": s.skill_author, "category": s.skill_category})
            
        return self.ovos_skills_model
        
    def build_pling_skills_model(self):
        self.pling_skills_model.clear()
        for s in get_pling_skills(parse_github=False):
            self.pling_skills_model.append({"title": s.skill_name, "description": s.skill_description, "logo": s.json.get("logo"), "author": s.skill_author, "category": s.skill_category})
            
        return self.pling_skills_model

def create_skill():
    return OSMInstaller()
