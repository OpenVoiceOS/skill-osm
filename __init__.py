import datetime
import time
import validators
# from os import path

from mycroft.skills.core import (MycroftSkill,
                                 intent_handler, intent_file_handler)
from mycroft.messagebus.message import Message
from ovos_skills_manager.osm import OVOSSkillsManager
from ovos_skills_manager.appstores.pling import get_pling_skills
from ovos_skills_manager.appstores.ovos import get_ovos_skills
from json_database import JsonStorage


class AppStoreModel:
    app_store_name: str
    model: list
    db_loc: str
    storage: JsonStorage

    def __init__(self, name: str, model: list, db_loc: str):
        self.app_store_name = name
        self.model = model
        self.db_loc = db_loc

class OSMInstaller(MycroftSkill):

    def __init__(self):
        super(OSMInstaller, self).__init__(name="OSMInstaller")
        self.osm_manager = OVOSSkillsManager()
        self.enabled_appstores = self.osm_manager.get_active_appstores()
        self.appstores = {}
        # self.osm_manager.enable_appstore("ovos")
        # self.osm_manager.enable_appstore("pling")
        # self.ovos_skills_model = []
        # self.pling_skills_model = []
        # self.ovosDB = path.join(self.file_system.path, 'ovos-list.db')
        # self.ovos_storage = JsonStorage(self.ovosDB)
        # self.plingDB = path.join(self.file_system.path, 'pling-list.db')
        # self.pling_storage = JsonStorage(self.plingDB)

        for _, appstore in self.enabled_appstores:
            self.appstores[appstore] = AppStoreModel(
                name=appstore.appstore_id,
                model=[],
                db_loc=appstore.db
            )
        self.search_skills_model = []

    def initialize(self):
        self.add_event("OSMInstaller.openvoiceos.home",
                       self.handle_display_home)
        self.add_event("osm.sync.finish",
                       self.update_display_model)
        self.add_event("osm.install.finish", self.display_installer_success)
        self.add_event("osm.install.error", self.display_installer_failure)
        self.gui.register_handler("OSMInstaller.openvoiceos.install",
                                  self.handle_install)

        # Build The Initial Display Model Without Sync
        # Make Sure Models Are Built Early To Avoid Display Call Delay
        self.update_display_model()

        # First Sync
        # s = self.osm_manager.get_active_appstores()
        # self.log.info(s.keys())
        self.log.info(self.enabled_appstores.keys())
        self.osm_manager.sync_appstores()
        # Start A Scheduled Event for Syncing OSM data
        now = datetime.datetime.now()
        callback_time = datetime.datetime(
            now.year, now.month, now.day, now.hour, now.minute
        ) + datetime.timedelta(seconds=60)
        self.schedule_repeating_event(self.sync_osm_model, callback_time, 9000)

    @intent_file_handler("show-osm.intent")
    def handle_display_home(self):
        self.gui.show_page("AppstoreHome.qml", override_idle=True)

    @intent_file_handler("search-osm.intent")
    def handle_search_osm_intent(self, message):
        utterance = message.data.get("description", "")
        if utterance is not None:
            results = self.osm_manager.search_skills(utterance)
            for s in results:
                if s.skill_name is not None:
                    self.search_skills_model.append({
                        "title": s.skill_name,
                        "description": s.skill_description,
                        "logo": s.json.get("logo"),
                        "author": s.skill_author,
                        "category": s.skill_category,
                        "url": s.url
                        })

            self.gui["appstore_pling_model"] = self.search_skills_model

    def build_skills_model(self, appstore):
        self.log.info("Building model for " + appstore)

        if appstore == "ovos":
            self.log.info("Selected OVOS Appstore")
            # appstore_ovos_model = self.build_ovos_skills_model()
            # self.ovos_storage["model"] = appstore_ovos_model
            storage = self.appstores["ovos"].storage = self.build_ovos_skills_model()
            storage.store()
        elif appstore == "pling":
            self.log.info("Selected Pling Appstore")
            # if "model" not in self.pling_storage:
            if "model" not in self.appstores["pling"].storage:
                # appstore_pling_model = self.build_pling_skills_model()
                # self.pling_storage["model"] = appstore_pling_model
                # self.pling_storage.store()
                storage = self.appstores["pling"].storage = self.build_pling_skills_model()
                storage.store()

        else:
            self.log.info("no valid appstore requested")

    # Build Custom Display Model For OVOS Skill Store
    def build_ovos_skills_model(self):
        # self.ovos_skills_model.clear()
        self.appstores["ovos"].model.clear()
        for s in get_ovos_skills(parse_github=False):
            if s.skill_name is not None:
                self.log.info(validators.url(s.skill_icon))
                if validators.url(s.skill_icon):
                    skill_icon = s.skill_icon
                else:
                    skill_icon = "https://iconarchive.com/download/i103156\
                    /blackvariant/button-ui-requests-9/Parcel.ico"
                self.appstores["ovos"].model.append({
                    "title": s.skill_name,
                    "description": s.skill_description,
                    "logo": skill_icon,
                    "author": s.skill_author,
                    "category": s.skill_category,
                    "url": s.url
                    })

        return self.appstores["ovos"]

    # Build Custom Display Model For Pling Skill Store
    def build_pling_skills_model(self):
        self.appstores["pling"].model.clear()
        for s in get_pling_skills(parse_github=False):
            if s.skill_name is not None:
                self.appstores["pling"].model.append({
                    "title": s.skill_name,
                    "description": s.skill_description,
                    "logo": s.json.get("logo"),
                    "author": s.skill_author,
                    "category": s.skill_category,
                    "url": s.url
                    })

        return self.appstores["pling"].model

    def handle_install(self, message):
        skill_url = message.data.get("url")
        self.gui["installer_status"] = 1 # Running
        self.log.info("Got request to install: " + skill_url)
        self.osm_manager.install_skill_from_url(skill_url)

    def sync_osm_model(self):
        self.osm_manager.sync_appstores()

    def update_display_model(self):
        self.build_skills_model("ovos")
        self.build_skills_model("pling")
        self.update_display_data()

    def update_display_data(self):
        self.gui["installer_status"] = 0 # Idle / Unknown
        self.gui["appstore_ovos_model"] = self.appstores["ovos"] #self.ovos_storage["model"]
        self.gui["appstore_pling_model"] = self.appstores["pling"] #self.pling_storage["model"]

    def display_installer_success(self):
        self.log.info("Installer Successful")
        self.gui["installer_status"] = 2 # Success
        time.sleep(2)
        update_display_model()

    def display_installer_failure(self):
        self.log.info("Installer Failed")
        self.gui["installer_status"] = 3 # Fail
        time.sleep(2)
        update_display_model()

def create_skill():
    return OSMInstaller()
