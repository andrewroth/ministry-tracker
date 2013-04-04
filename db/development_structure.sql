CREATE TABLE `accountadmin_accesscategory` (
  `accesscategory_id` int(11) NOT NULL AUTO_INCREMENT,
  `accesscategory_key` varchar(50) NOT NULL DEFAULT '',
  `english_value` text,
  PRIMARY KEY (`accesscategory_id`),
  KEY `ciministry.accountadmin_accesscategory_accesscateg` (`accesscategory_key`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_accessgroup` (
  `accessgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `accesscategory_id` int(11) NOT NULL DEFAULT '0',
  `accessgroup_key` varchar(50) NOT NULL DEFAULT '',
  `english_value` text,
  PRIMARY KEY (`accessgroup_id`),
  KEY `ciministry.accountadmin_accessgroup_accessgroup_ke` (`accessgroup_key`)
) ENGINE=MyISAM AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_accountadminaccess` (
  `accountadminaccess_id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) NOT NULL DEFAULT '0',
  `accountadminaccess_privilege` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`accountadminaccess_id`),
  KEY `ciministry.accountadmin_accountadminaccess_viewer_` (`viewer_id`),
  KEY `ciministry.accountadmin_accountadminaccess_account` (`accountadminaccess_privilege`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_accountgroup` (
  `accountgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `accountgroup_key` varchar(50) NOT NULL DEFAULT '',
  `accountgroup_label_long` varchar(50) NOT NULL DEFAULT '',
  `english_value` text,
  PRIMARY KEY (`accountgroup_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_language` (
  `language_id` int(11) NOT NULL AUTO_INCREMENT,
  `language_key` varchar(25) NOT NULL DEFAULT '',
  `language_code` char(2) NOT NULL DEFAULT '',
  `english_value` text,
  PRIMARY KEY (`language_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_viewer` (
  `viewer_id` int(11) NOT NULL AUTO_INCREMENT,
  `guid` varchar(64) DEFAULT '',
  `accountgroup_id` int(11) NOT NULL DEFAULT '0',
  `viewer_userID` varchar(50) NOT NULL DEFAULT '',
  `viewer_passWord` varchar(50) DEFAULT '',
  `language_id` int(11) NOT NULL DEFAULT '0',
  `viewer_isActive` int(1) NOT NULL DEFAULT '0',
  `viewer_lastLogin` datetime DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `email_validated` tinyint(1) DEFAULT NULL,
  `developer` tinyint(1) DEFAULT NULL,
  `facebook_hash` varchar(255) DEFAULT NULL,
  `facebook_username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`viewer_id`),
  KEY `ciministry.accountadmin_viewer_accountgroup_id_index` (`accountgroup_id`),
  KEY `ciministry.accountadmin_viewer_viewer_userID_index` (`viewer_userID`),
  CONSTRAINT `FK_viewer_grp` FOREIGN KEY (`accountgroup_id`) REFERENCES `accountadmin_accountgroup` (`accountgroup_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17215 DEFAULT CHARSET=latin1;

CREATE TABLE `accountadmin_vieweraccessgroup` (
  `vieweraccessgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) NOT NULL DEFAULT '0',
  `accessgroup_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`vieweraccessgroup_id`),
  KEY `ciministry.accountadmin_vieweraccessgroup_viewer_i` (`viewer_id`),
  KEY `ciministry.accountadmin_vieweraccessgroup_accessgr` (`accessgroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=26107 DEFAULT CHARSET=latin1;

CREATE TABLE `activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_type_id` int(11) DEFAULT NULL,
  `reportable_id` int(11) DEFAULT NULL,
  `reportable_type` varchar(255) DEFAULT NULL,
  `reporter_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_activities_on_reportable_type_and_reportable_id` (`reportable_type`,`reportable_id`),
  KEY `index_activities_on_reporter_id` (`reporter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=633 DEFAULT CHARSET=utf8;

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `address_type` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `alternate_phone` varchar(255) DEFAULT NULL,
  `dorm` varchar(255) DEFAULT NULL,
  `room` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  `updated_at` date DEFAULT NULL,
  `email_validated` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_addresses_on_email` (`email`),
  KEY `index_addresses_on_person_id` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `api_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `login_code_id` int(11) DEFAULT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `campus_involvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  `added_by_id` int(11) DEFAULT NULL,
  `graduation_date` date DEFAULT NULL,
  `school_year_id` int(11) DEFAULT NULL,
  `major` varchar(255) DEFAULT NULL,
  `minor` varchar(255) DEFAULT NULL,
  `last_history_update_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_campus_involvements_on_p_id_and_c_id_and_end_date` (`person_id`,`campus_id`,`end_date`),
  KEY `index_campus_involvements_on_campus_id` (`campus_id`),
  KEY `index_campus_involvements_on_ministry_id` (`ministry_id`),
  KEY `index_campus_involvements_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9640 DEFAULT CHARSET=utf8;

CREATE TABLE `campus_ministry_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=726 DEFAULT CHARSET=utf8;

CREATE TABLE `campuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `abbrv` varchar(255) DEFAULT NULL,
  `is_secure` tinyint(1) DEFAULT NULL,
  `enrollment` int(11) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  `updated_at` date DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `county` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_campuses_on_county` (`county`),
  KEY `index_campuses_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cim_c4cwebsite_projects` (
  `projects_id` int(10) NOT NULL AUTO_INCREMENT,
  `projects_desc` varchar(50) NOT NULL DEFAULT '',
  `project_website` varchar(200) DEFAULT NULL,
  `project_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`projects_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_access` (
  `access_id` int(50) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(50) NOT NULL DEFAULT '0',
  `person_id` int(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`access_id`),
  KEY `ciministry.cim_hrdb_access_viewer_id_index` (`viewer_id`),
  KEY `ciministry.cim_hrdb_access_person_id_index` (`person_id`),
  CONSTRAINT `FK_access_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16973 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_activityschedule` (
  `activityschedule_id` int(15) NOT NULL AUTO_INCREMENT,
  `staffactivity_id` int(15) NOT NULL DEFAULT '0',
  `staffschedule_id` int(15) NOT NULL DEFAULT '0',
  PRIMARY KEY (`activityschedule_id`),
  KEY `FK_activity_schedule` (`staffschedule_id`),
  KEY `FK_schedule_activity` (`staffactivity_id`),
  CONSTRAINT `FK_activity_schedule` FOREIGN KEY (`staffschedule_id`) REFERENCES `cim_hrdb_staffschedule` (`staffschedule_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_schedule_activity` FOREIGN KEY (`staffactivity_id`) REFERENCES `cim_hrdb_staffactivity` (`staffactivity_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=815 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_activitytype` (
  `activitytype_id` int(10) NOT NULL AUTO_INCREMENT,
  `activitytype_desc` varchar(75) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `activitytype_abbr` varchar(6) COLLATE latin1_general_ci NOT NULL,
  `activitytype_color` varchar(7) COLLATE latin1_general_ci NOT NULL DEFAULT '#0000FF',
  PRIMARY KEY (`activitytype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_admin` (
  `admin_id` int(1) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `priv_id` int(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`admin_id`),
  KEY `FK_hrdbadmin_person` (`person_id`),
  KEY `FK_admin_priv` (`priv_id`),
  CONSTRAINT `FK_admin_priv` FOREIGN KEY (`priv_id`) REFERENCES `cim_hrdb_priv` (`priv_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_hrdbadmin_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_assignment` (
  `assignment_id` int(50) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `campus_id` int(50) NOT NULL DEFAULT '0',
  `assignmentstatus_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`assignment_id`),
  KEY `ciministry.cim_hrdb_assignment_person_id_index` (`person_id`),
  KEY `ciministry.cim_hrdb_assignment_campus_id_index` (`campus_id`),
  CONSTRAINT `FK_assign_campus` FOREIGN KEY (`campus_id`) REFERENCES `cim_hrdb_campus` (`campus_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_assign_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8491 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_assignmentstatus` (
  `assignmentstatus_id` int(10) NOT NULL AUTO_INCREMENT,
  `assignmentstatus_desc` varchar(64) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`assignmentstatus_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_campus` (
  `campus_id` int(50) NOT NULL AUTO_INCREMENT,
  `campus_desc` varchar(128) NOT NULL DEFAULT '',
  `campus_shortDesc` varchar(50) NOT NULL DEFAULT '',
  `accountgroup_id` int(16) NOT NULL DEFAULT '0',
  `region_id` int(8) NOT NULL DEFAULT '0',
  `campus_website` varchar(128) NOT NULL DEFAULT '',
  `campus_facebookgroup` varchar(128) NOT NULL,
  `campus_gcxnamespace` varchar(128) NOT NULL,
  `province_id` int(11) DEFAULT NULL,
  `longitude` decimal(10,6) DEFAULT NULL,
  `latitude` decimal(10,6) DEFAULT NULL,
  PRIMARY KEY (`campus_id`),
  KEY `ciministry.cim_hrdb_campus_region_id_index` (`region_id`),
  KEY `ciministry.cim_hrdb_campus_accountgroup_id_index` (`accountgroup_id`),
  KEY `index_ciministry.cim_hrdb_campus_on_longitude` (`longitude`),
  KEY `index_ciministry.cim_hrdb_campus_on_latitude` (`latitude`),
  CONSTRAINT `FK_campus_region` FOREIGN KEY (`region_id`) REFERENCES `cim_hrdb_region` (`region_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_campusadmin` (
  `campusadmin_id` int(20) NOT NULL AUTO_INCREMENT,
  `admin_id` int(20) NOT NULL DEFAULT '0',
  `campus_id` int(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`campusadmin_id`),
  KEY `ciministry.cim_hrdb_campusadmin_admin_id_index` (`admin_id`),
  KEY `ciministry.cim_hrdb_campusadmin_campus_id_index` (`campus_id`),
  CONSTRAINT `FK_campusadmin_campus` FOREIGN KEY (`campus_id`) REFERENCES `cim_hrdb_campus` (`campus_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_campus_hrdbadmin` FOREIGN KEY (`admin_id`) REFERENCES `cim_hrdb_admin` (`admin_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_country` (
  `country_id` int(50) NOT NULL AUTO_INCREMENT,
  `country_desc` varchar(50) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `country_shortDesc` varchar(50) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_customfields` (
  `customfields_id` int(16) unsigned NOT NULL AUTO_INCREMENT,
  `report_id` int(10) unsigned NOT NULL,
  `fields_id` int(16) NOT NULL,
  PRIMARY KEY (`customfields_id`),
  KEY `FK_fields_report` (`report_id`),
  KEY `FK_report_field` (`fields_id`),
  CONSTRAINT `FK_fields_report` FOREIGN KEY (`report_id`) REFERENCES `cim_hrdb_customreports` (`report_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_report_field` FOREIGN KEY (`fields_id`) REFERENCES `cim_hrdb_fields` (`fields_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_customreports` (
  `report_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `report_name` varchar(64) COLLATE latin1_general_ci NOT NULL,
  `report_is_shown` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`report_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_emerg` (
  `emerg_id` int(16) NOT NULL AUTO_INCREMENT,
  `person_id` int(16) NOT NULL DEFAULT '0',
  `emerg_passportNum` varchar(32) NOT NULL DEFAULT '',
  `emerg_passportOrigin` varchar(32) NOT NULL DEFAULT '',
  `emerg_passportExpiry` date NOT NULL DEFAULT '0000-00-00',
  `emerg_contactName` varchar(64) NOT NULL DEFAULT '',
  `emerg_contactRship` varchar(64) NOT NULL DEFAULT '',
  `emerg_contactHome` varchar(32) NOT NULL DEFAULT '',
  `emerg_contactWork` varchar(32) NOT NULL DEFAULT '',
  `emerg_contactMobile` varchar(32) NOT NULL DEFAULT '',
  `emerg_contactEmail` varchar(32) NOT NULL DEFAULT '',
  `emerg_birthdate` date NOT NULL DEFAULT '0000-00-00',
  `emerg_medicalNotes` text NOT NULL,
  `emerg_contact2Name` varchar(64) NOT NULL,
  `emerg_contact2Rship` varchar(64) NOT NULL,
  `emerg_contact2Home` varchar(64) NOT NULL,
  `emerg_contact2Work` varchar(64) NOT NULL,
  `emerg_contact2Mobile` varchar(64) NOT NULL,
  `emerg_contact2Email` varchar(64) NOT NULL,
  `emerg_meds` text NOT NULL,
  `health_province_id` int(11) DEFAULT NULL,
  `health_number` varchar(255) DEFAULT NULL,
  `medical_plan_number` varchar(255) DEFAULT NULL,
  `medical_plan_carrier` varchar(255) DEFAULT NULL,
  `doctor_name` varchar(255) DEFAULT NULL,
  `doctor_phone` varchar(255) DEFAULT NULL,
  `dentist_name` varchar(255) DEFAULT NULL,
  `dentist_phone` varchar(255) DEFAULT NULL,
  `blood_type` varchar(255) DEFAULT NULL,
  `blood_rh_factor` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `health_coverage_country` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`emerg_id`),
  KEY `ciministry.cim_hrdb_emerg_person_id_index` (`person_id`),
  CONSTRAINT `FK_emerg_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10242 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_fieldgroup` (
  `fieldgroup_id` int(10) NOT NULL AUTO_INCREMENT,
  `fieldgroup_desc` varchar(75) COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`fieldgroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_fieldgroup_matches` (
  `fieldgroup_matches_id` int(20) NOT NULL AUTO_INCREMENT,
  `fieldgroup_id` int(10) NOT NULL DEFAULT '0',
  `fields_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`fieldgroup_matches_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_fields` (
  `fields_id` int(16) NOT NULL AUTO_INCREMENT,
  `fieldtype_id` int(16) NOT NULL DEFAULT '0',
  `fields_desc` text NOT NULL,
  `staffscheduletype_id` int(15) NOT NULL DEFAULT '0',
  `fields_priority` int(16) NOT NULL DEFAULT '0',
  `fields_reqd` int(8) NOT NULL DEFAULT '0',
  `fields_invalid` varchar(128) NOT NULL DEFAULT '',
  `fields_hidden` int(8) NOT NULL DEFAULT '0',
  `datatypes_id` int(4) NOT NULL DEFAULT '0',
  `fieldgroup_id` int(10) NOT NULL DEFAULT '0',
  `fields_note` varchar(75) NOT NULL,
  PRIMARY KEY (`fields_id`),
  KEY `FK_fields_types2` (`fieldtype_id`),
  KEY `FK_fields_form` (`staffscheduletype_id`),
  KEY `FK_fields_dtype2` (`datatypes_id`),
  CONSTRAINT `FK_fields_dtype2` FOREIGN KEY (`datatypes_id`) REFERENCES `cim_reg_datatypes` (`datatypes_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fields_form` FOREIGN KEY (`staffscheduletype_id`) REFERENCES `cim_hrdb_staffscheduletype` (`staffscheduletype_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fields_types2` FOREIGN KEY (`fieldtype_id`) REFERENCES `cim_reg_fieldtypes` (`fieldtypes_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_fieldvalues` (
  `fieldvalues_id` int(16) NOT NULL AUTO_INCREMENT,
  `fields_id` int(16) NOT NULL DEFAULT '0',
  `fieldvalues_value` text NOT NULL,
  `person_id` int(16) NOT NULL DEFAULT '0',
  `fieldvalues_modTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`fieldvalues_id`),
  KEY `FK_fieldvals_person` (`person_id`),
  KEY `FK_fieldvals_field2` (`fields_id`),
  CONSTRAINT `FK_fieldvals_field2` FOREIGN KEY (`fields_id`) REFERENCES `cim_hrdb_fields` (`fields_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fieldvals_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1839 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_gender` (
  `gender_id` int(50) NOT NULL AUTO_INCREMENT,
  `gender_desc` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`gender_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_ministry` (
  `ministry_id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `ministry_name` varchar(64) COLLATE latin1_general_ci NOT NULL,
  `ministry_abbrev` varchar(16) COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`ministry_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_person` (
  `person_id` int(50) NOT NULL AUTO_INCREMENT,
  `person_fname` varchar(50) NOT NULL DEFAULT '',
  `person_lname` varchar(50) NOT NULL DEFAULT '',
  `person_legal_fname` varchar(50) NOT NULL,
  `person_legal_lname` varchar(50) NOT NULL,
  `person_phone` varchar(50) NOT NULL DEFAULT '',
  `person_email` varchar(128) NOT NULL DEFAULT '',
  `person_addr` varchar(128) NOT NULL DEFAULT '',
  `person_city` varchar(50) NOT NULL DEFAULT '',
  `province_id` int(50) NOT NULL DEFAULT '0',
  `person_pc` varchar(50) NOT NULL DEFAULT '',
  `gender_id` int(50) NOT NULL DEFAULT '0',
  `person_local_phone` varchar(50) NOT NULL DEFAULT '',
  `person_local_addr` varchar(128) NOT NULL DEFAULT '',
  `person_local_city` varchar(50) NOT NULL DEFAULT '',
  `person_local_pc` varchar(50) NOT NULL DEFAULT '',
  `person_local_province_id` int(50) NOT NULL DEFAULT '0',
  `cell_phone` varchar(255) DEFAULT NULL,
  `local_valid_until` date DEFAULT NULL,
  `title_id` int(11) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `person_local_country_id` int(11) DEFAULT NULL,
  `person_mname` varchar(255) DEFAULT NULL,
  `person_mentor_id` int(11) DEFAULT NULL,
  `person_mentees_lft` int(11) DEFAULT NULL,
  `person_mentees_rgt` int(11) DEFAULT NULL,
  `facebook_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`person_id`),
  KEY `ciministry.cim_hrdb_person_gender_id_index` (`gender_id`),
  KEY `ciministry.cim_hrdb_person_province_id_index` (`province_id`),
  KEY `index_ciministry.cim_hrdb_person_on_person_email` (`person_email`),
  KEY `index_ciministry.cim_hrdb_person_on_person_mentor_id` (`person_mentor_id`),
  KEY `index_ciministry.cim_hrdb_person_on_person_fname` (`person_fname`),
  KEY `index_ciministry.cim_hrdb_person_on_person_lname` (`person_lname`)
) ENGINE=InnoDB AUTO_INCREMENT=1360714651 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_person_year` (
  `personyear_id` int(50) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `year_id` int(50) NOT NULL DEFAULT '0',
  `grad_date` date DEFAULT '0000-00-00',
  PRIMARY KEY (`personyear_id`),
  KEY `FK_cim_hrdb_person_year` (`person_id`),
  KEY `1` (`year_id`),
  CONSTRAINT `1` FOREIGN KEY (`year_id`) REFERENCES `cim_hrdb_year_in_school` (`year_id`),
  CONSTRAINT `FK_year_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3554 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

CREATE TABLE `cim_hrdb_priv` (
  `priv_id` int(20) NOT NULL AUTO_INCREMENT,
  `priv_accesslevel` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`priv_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_province` (
  `province_id` int(50) NOT NULL AUTO_INCREMENT,
  `province_desc` varchar(50) NOT NULL DEFAULT '',
  `province_shortDesc` varchar(50) NOT NULL DEFAULT '',
  `country_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`province_id`)
) ENGINE=MyISAM AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_region` (
  `region_id` int(50) NOT NULL AUTO_INCREMENT,
  `reg_desc` varchar(64) NOT NULL DEFAULT '',
  `country_id` int(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`region_id`),
  KEY `FK_region_country` (`country_id`),
  CONSTRAINT `FK_region_country` FOREIGN KEY (`country_id`) REFERENCES `cim_hrdb_country` (`country_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_staff` (
  `staff_id` int(50) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `is_active` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `unique_person` (`person_id`),
  KEY `ciministry.cim_hrdb_staff_person_id_index` (`person_id`),
  CONSTRAINT `FK_staff_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=455 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_staffactivity` (
  `staffactivity_id` int(15) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `staffactivity_startdate` date NOT NULL DEFAULT '0000-00-00',
  `staffactivity_enddate` date NOT NULL DEFAULT '0000-00-00',
  `staffactivity_contactPhone` varchar(20) COLLATE latin1_general_ci NOT NULL,
  `activitytype_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`staffactivity_id`),
  KEY `FK_activity_type` (`activitytype_id`),
  KEY `FK_activity_person` (`person_id`),
  CONSTRAINT `FK_activity_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_activity_type` FOREIGN KEY (`activitytype_id`) REFERENCES `cim_hrdb_activitytype` (`activitytype_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=818 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_staffdirector` (
  `staffdirector_id` int(60) unsigned NOT NULL AUTO_INCREMENT,
  `staff_id` int(50) NOT NULL,
  `director_id` int(50) NOT NULL,
  PRIMARY KEY (`staffdirector_id`),
  KEY `FK_director_staff` (`director_id`),
  KEY `FK_staff_staff1` (`staff_id`),
  CONSTRAINT `FK_director_staff` FOREIGN KEY (`director_id`) REFERENCES `cim_hrdb_staff` (`staff_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_staff_staff1` FOREIGN KEY (`staff_id`) REFERENCES `cim_hrdb_staff` (`staff_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_staffschedule` (
  `staffschedule_id` int(15) NOT NULL AUTO_INCREMENT,
  `person_id` int(50) NOT NULL DEFAULT '0',
  `staffscheduletype_id` int(15) NOT NULL DEFAULT '0',
  `staffschedule_approved` int(2) NOT NULL DEFAULT '0',
  `staffschedule_approvedby` int(50) NOT NULL DEFAULT '0',
  `staffschedule_lastmodifiedbydirector` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `staffschedule_approvalnotes` text COLLATE latin1_general_ci NOT NULL,
  `staffschedule_tonotify` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`staffschedule_id`),
  KEY `FK_schedule_type` (`staffscheduletype_id`),
  KEY `FK_schedule_person1` (`person_id`),
  CONSTRAINT `FK_schedule_person1` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_schedule_type` FOREIGN KEY (`staffscheduletype_id`) REFERENCES `cim_hrdb_staffscheduletype` (`staffscheduletype_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_staffscheduleinstr` (
  `staffscheduletype_id` int(15) NOT NULL,
  `staffscheduleinstr_toptext` text COLLATE latin1_general_ci NOT NULL,
  `staffscheduleinstr_bottomtext` text COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`staffscheduletype_id`),
  CONSTRAINT `FK_instr_schedtype` FOREIGN KEY (`staffscheduletype_id`) REFERENCES `cim_hrdb_staffscheduletype` (`staffscheduletype_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_staffscheduletype` (
  `staffscheduletype_id` int(15) NOT NULL AUTO_INCREMENT,
  `staffscheduletype_desc` varchar(75) COLLATE latin1_general_ci NOT NULL,
  `staffscheduletype_startdate` date NOT NULL DEFAULT '0000-00-00',
  `staffscheduletype_enddate` date NOT NULL DEFAULT '0000-00-00',
  `staffscheduletype_has_activities` int(2) NOT NULL DEFAULT '1',
  `staffscheduletype_has_activity_phone` int(2) NOT NULL DEFAULT '0',
  `staffscheduletype_activity_types` varchar(25) COLLATE latin1_general_ci NOT NULL,
  `staffscheduletype_is_shown` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`staffscheduletype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_hrdb_title` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `desc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_hrdb_year_in_school` (
  `year_id` int(11) NOT NULL AUTO_INCREMENT,
  `year_desc` char(50) NOT NULL DEFAULT '',
  `position` int(11) DEFAULT NULL,
  `translation_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`year_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_activerules` (
  `pricerules_id` int(16) NOT NULL DEFAULT '0',
  `is_active` int(1) NOT NULL DEFAULT '0',
  `is_recalculated` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`pricerules_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_campusaccess` (
  `campusaccess_id` int(16) NOT NULL AUTO_INCREMENT,
  `eventadmin_id` int(16) NOT NULL DEFAULT '0',
  `campus_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`campusaccess_id`)
) ENGINE=MyISAM AUTO_INCREMENT=217 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_cashtransaction` (
  `cashtransaction_id` int(16) NOT NULL AUTO_INCREMENT,
  `reg_id` int(16) NOT NULL DEFAULT '0',
  `cashtransaction_staffName` varchar(64) NOT NULL DEFAULT '',
  `cashtransaction_recd` int(8) NOT NULL DEFAULT '0',
  `cashtransaction_amtPaid` float NOT NULL DEFAULT '0',
  `cashtransaction_moddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cashtransaction_id`),
  KEY `FK_cashtrans_reg` (`reg_id`),
  CONSTRAINT `FK_cashtrans_reg` FOREIGN KEY (`reg_id`) REFERENCES `cim_reg_registration` (`registration_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4821 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_ccreceipt` (
  `ccreceipt_sequencenum` varchar(18) NOT NULL,
  `ccreceipt_authcode` varchar(8) DEFAULT NULL,
  `ccreceipt_responsecode` char(3) NOT NULL DEFAULT '',
  `ccreceipt_message` varchar(100) NOT NULL DEFAULT '',
  `ccreceipt_moddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cctransaction_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cctransaction_id`),
  CONSTRAINT `FK_receipt_cctrans` FOREIGN KEY (`cctransaction_id`) REFERENCES `cim_reg_cctransaction` (`cctransaction_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_cctransaction` (
  `cctransaction_id` int(16) NOT NULL AUTO_INCREMENT,
  `reg_id` int(16) NOT NULL DEFAULT '0',
  `cctransaction_cardName` varchar(64) NOT NULL DEFAULT '',
  `cctype_id` int(16) NOT NULL DEFAULT '0',
  `cctransaction_cardNum` text NOT NULL,
  `cctransaction_expiry` varchar(64) NOT NULL DEFAULT '',
  `cctransaction_billingPC` varchar(64) NOT NULL DEFAULT '',
  `cctransaction_processed` int(16) NOT NULL DEFAULT '0',
  `cctransaction_amount` float NOT NULL DEFAULT '0',
  `cctransaction_moddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cctransaction_refnum` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cctransaction_id`),
  KEY `FK_cctrans_reg` (`reg_id`),
  KEY `FK_cctrans_ccid` (`cctype_id`),
  CONSTRAINT `FK_cctrans_ccid` FOREIGN KEY (`cctype_id`) REFERENCES `cim_reg_cctype` (`cctype_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_cctrans_reg` FOREIGN KEY (`reg_id`) REFERENCES `cim_reg_registration` (`registration_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5177 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_cctype` (
  `cctype_id` int(16) NOT NULL AUTO_INCREMENT,
  `cctype_desc` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`cctype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_datatypes` (
  `datatypes_id` int(4) NOT NULL AUTO_INCREMENT,
  `datatypes_key` varchar(8) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `datatypes_desc` varchar(64) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`datatypes_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `cim_reg_event` (
  `event_id` int(50) NOT NULL AUTO_INCREMENT,
  `country_id` int(50) NOT NULL DEFAULT '0',
  `ministry_id` int(20) unsigned NOT NULL DEFAULT '0',
  `event_name` varchar(128) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `event_descBrief` varchar(128) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `event_descDetail` text CHARACTER SET latin1 NOT NULL,
  `event_startDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_endDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_regStart` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_regEnd` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `event_website` varchar(128) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `event_emailConfirmText` text CHARACTER SET latin1 NOT NULL,
  `event_basePrice` float NOT NULL DEFAULT '0',
  `event_deposit` float NOT NULL DEFAULT '0',
  `event_contactEmail` text CHARACTER SET latin1 NOT NULL,
  `event_pricingText` text CHARACTER SET latin1 NOT NULL,
  `event_onHomePage` int(1) NOT NULL DEFAULT '1',
  `event_allowCash` int(1) NOT NULL DEFAULT '0',
  `hide_from_profile` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;

CREATE TABLE `cim_reg_eventadmin` (
  `eventadmin_id` int(16) NOT NULL AUTO_INCREMENT,
  `event_id` int(16) NOT NULL DEFAULT '0',
  `priv_id` int(16) NOT NULL DEFAULT '0',
  `viewer_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`eventadmin_id`),
  KEY `FK_admin_event` (`event_id`),
  KEY `FK_admin_viewer` (`viewer_id`),
  KEY `FK_evadmin_priv` (`priv_id`),
  CONSTRAINT `FK_admin_event` FOREIGN KEY (`event_id`) REFERENCES `cim_reg_event` (`event_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_admin_viewer` FOREIGN KEY (`viewer_id`) REFERENCES `accountadmin_viewer` (`viewer_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_evadmin_priv` FOREIGN KEY (`priv_id`) REFERENCES `cim_reg_priv` (`priv_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=404 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_fields` (
  `fields_id` int(16) NOT NULL AUTO_INCREMENT,
  `fieldtype_id` int(16) NOT NULL DEFAULT '0',
  `fields_desc` text NOT NULL,
  `event_id` int(16) NOT NULL DEFAULT '0',
  `fields_priority` int(16) NOT NULL DEFAULT '0',
  `fields_reqd` int(8) NOT NULL DEFAULT '0',
  `fields_invalid` varchar(128) NOT NULL DEFAULT '',
  `fields_hidden` int(8) NOT NULL DEFAULT '0',
  `datatypes_id` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`fields_id`),
  KEY `FK_fields_types` (`fieldtype_id`),
  KEY `FK_fields_event` (`event_id`),
  KEY `FK_fields_dtype` (`datatypes_id`),
  CONSTRAINT `FK_fields_dtype` FOREIGN KEY (`datatypes_id`) REFERENCES `cim_reg_datatypes` (`datatypes_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fields_event` FOREIGN KEY (`event_id`) REFERENCES `cim_reg_event` (`event_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fields_types` FOREIGN KEY (`fieldtype_id`) REFERENCES `cim_reg_fieldtypes` (`fieldtypes_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_fieldtypes` (
  `fieldtypes_id` int(16) NOT NULL AUTO_INCREMENT,
  `fieldtypes_desc` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`fieldtypes_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_fieldvalues` (
  `fieldvalues_id` int(16) NOT NULL AUTO_INCREMENT,
  `fields_id` int(16) NOT NULL DEFAULT '0',
  `fieldvalues_value` text NOT NULL,
  `registration_id` int(16) NOT NULL DEFAULT '0',
  `fieldvalues_modTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`fieldvalues_id`),
  KEY `FK_fieldvals_reg` (`registration_id`),
  KEY `FK_fieldvals_field` (`fields_id`),
  CONSTRAINT `FK_fieldvals_field` FOREIGN KEY (`fields_id`) REFERENCES `cim_reg_fields` (`fields_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_fieldvals_reg` FOREIGN KEY (`registration_id`) REFERENCES `cim_reg_registration` (`registration_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45881 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_pricerules` (
  `pricerules_id` int(16) NOT NULL AUTO_INCREMENT,
  `event_id` int(16) NOT NULL DEFAULT '0',
  `priceruletypes_id` int(16) NOT NULL DEFAULT '0',
  `pricerules_desc` text NOT NULL,
  `fields_id` int(10) NOT NULL DEFAULT '0',
  `pricerules_value` varchar(128) NOT NULL DEFAULT '',
  `pricerules_discount` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`pricerules_id`),
  KEY `FK_prules_event` (`event_id`),
  KEY `FK_prules_type` (`priceruletypes_id`),
  CONSTRAINT `FK_prules_event` FOREIGN KEY (`event_id`) REFERENCES `cim_reg_event` (`event_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_prules_type` FOREIGN KEY (`priceruletypes_id`) REFERENCES `cim_reg_priceruletypes` (`priceruletypes_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_priceruletypes` (
  `priceruletypes_id` int(16) NOT NULL AUTO_INCREMENT,
  `priceruletypes_desc` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`priceruletypes_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_priv` (
  `priv_id` int(10) NOT NULL AUTO_INCREMENT,
  `priv_desc` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`priv_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_registration` (
  `registration_id` int(50) NOT NULL AUTO_INCREMENT,
  `event_id` int(50) NOT NULL DEFAULT '0',
  `person_id` int(50) NOT NULL DEFAULT '0',
  `registration_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `registration_confirmNum` varchar(64) NOT NULL DEFAULT '',
  `registration_status` int(2) NOT NULL DEFAULT '0',
  `registration_balance` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`registration_id`),
  KEY `FK_reg_person` (`person_id`),
  KEY `FK_reg_status` (`registration_status`),
  CONSTRAINT `FK_reg_person` FOREIGN KEY (`person_id`) REFERENCES `cim_hrdb_person` (`person_id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_reg_status` FOREIGN KEY (`registration_status`) REFERENCES `cim_reg_status` (`status_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9550 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_scholarship` (
  `scholarship_id` int(16) NOT NULL AUTO_INCREMENT,
  `registration_id` int(16) NOT NULL DEFAULT '0',
  `scholarship_amount` float NOT NULL DEFAULT '0',
  `scholarship_sourceAcct` varchar(64) NOT NULL DEFAULT '',
  `scholarship_sourceDesc` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`scholarship_id`),
  KEY `FK_scholarship_reg` (`registration_id`),
  CONSTRAINT `FK_scholarship_reg` FOREIGN KEY (`registration_id`) REFERENCES `cim_reg_registration` (`registration_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2271 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_status` (
  `status_id` int(10) NOT NULL,
  `status_desc` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cim_reg_superadmin` (
  `superadmin_id` int(16) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`superadmin_id`),
  KEY `FK_viewer_regsuperadmin` (`viewer_id`),
  CONSTRAINT `FK_viewer_regsuperadmin` FOREIGN KEY (`viewer_id`) REFERENCES `accountadmin_viewer` (`viewer_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_access` (
  `access_id` int(16) NOT NULL AUTO_INCREMENT,
  `staff_id` int(16) NOT NULL DEFAULT '0',
  `priv_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`access_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_annualgoalsreport` (
  `annualGoalsReport_id` int(11) NOT NULL AUTO_INCREMENT,
  `campus_id` int(11) DEFAULT NULL,
  `year_id` int(11) DEFAULT NULL,
  `annualGoalsReport_studInMin` int(11) DEFAULT '0',
  `annualGoalsReport_sptMulti` int(11) DEFAULT '0',
  `annualGoalsReport_firstYears` int(11) DEFAULT '0',
  `annualGoalsReport_summitWent` int(11) DEFAULT '0',
  `annualGoalsReport_wcWent` int(11) DEFAULT '0',
  `annualGoalsReport_projWent` int(11) DEFAULT '0',
  `annualGoalsReport_spConvTotal` int(11) DEFAULT '0',
  `annualGoalsReport_gosPresTotal` int(11) DEFAULT '0',
  `annualGoalsReport_hsPresTotal` int(11) DEFAULT '0',
  `annualGoalsReport_prcTotal` int(11) DEFAULT '0',
  `annualGoalsReport_integBelievers` int(11) DEFAULT '0',
  `annualGoalsReport_lrgEventAttend` int(11) DEFAULT '0',
  PRIMARY KEY (`annualGoalsReport_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_annualreport` (
  `annualReport_id` int(11) NOT NULL AUTO_INCREMENT,
  `campus_id` int(11) DEFAULT NULL,
  `year_id` int(11) DEFAULT NULL,
  `annualReport_lnz_avgPrayer` int(11) DEFAULT '0',
  `annualReport_lnz_numFrosh` int(11) DEFAULT '0',
  `annualReport_lnz_totalStudentInDG` int(11) DEFAULT '0',
  `annualReport_lnz_totalSpMult` int(11) DEFAULT '0',
  `annualReport_lnz_totalCoreStudents` int(11) DEFAULT '0',
  `annualreport_lnz_p2c_numInEvangStudies` int(11) DEFAULT '0',
  `annualreport_lnz_p2c_numSharingInP2c` int(11) DEFAULT '0',
  `annualreport_lnz_p2c_numSharingOutP2c` int(11) DEFAULT '0',
  `annualReport_lnz_ministering_disciples` int(11) DEFAULT '0',
  PRIMARY KEY (`annualReport_id`)
) ENGINE=InnoDB AUTO_INCREMENT=183 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_coordinator` (
  `coordinator_id` int(16) NOT NULL AUTO_INCREMENT,
  `access_id` int(16) NOT NULL DEFAULT '0',
  `campus_id` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`coordinator_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_exposuretype` (
  `exposuretype_id` int(10) NOT NULL AUTO_INCREMENT,
  `exposuretype_desc` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`exposuretype_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_month` (
  `month_id` int(10) NOT NULL AUTO_INCREMENT,
  `month_desc` varchar(64) NOT NULL DEFAULT '',
  `month_number` int(8) NOT NULL DEFAULT '0',
  `year_id` int(10) NOT NULL DEFAULT '0',
  `month_calendaryear` int(10) NOT NULL,
  `semester_id` int(10) DEFAULT NULL,
  `month_literalyear` int(11) DEFAULT NULL,
  PRIMARY KEY (`month_id`)
) ENGINE=MyISAM AUTO_INCREMENT=133 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_monthlyreport` (
  `monthlyreport_id` int(11) NOT NULL AUTO_INCREMENT,
  `campus_id` int(11) DEFAULT NULL,
  `month_id` int(11) DEFAULT NULL,
  `monthlyreport_avgPrayer` int(11) DEFAULT '0',
  `monthlyreport_numFrosh` int(11) DEFAULT '0',
  `monthlyreport_eventSpirConversations` int(11) DEFAULT '0',
  `monthlyreport_eventGospPres` int(11) DEFAULT '0',
  `monthlyreport_mediaSpirConversations` int(11) DEFAULT '0',
  `monthlyreport_mediaGospPres` int(11) DEFAULT '0',
  `monthlyreport_totalCoreStudents` int(11) DEFAULT '0',
  `monthlyreport_totalStudentInDG` int(11) DEFAULT '0',
  `monthlyreport_totalSpMult` int(11) DEFAULT '0',
  `montlyreport_p2c_numInEvangStudies` int(11) DEFAULT '0',
  `montlyreport_p2c_numTrainedToShareInP2c` int(11) DEFAULT '0',
  `montlyreport_p2c_numTrainedToShareOutP2c` int(11) DEFAULT '0',
  `montlyreport_p2c_numSharingInP2c` int(11) DEFAULT '0',
  `montlyreport_p2c_numSharingOutP2c` int(11) DEFAULT '0',
  `montlyreport_integratedNewBelievers` int(11) DEFAULT '0',
  `monthlyreport_event_exposures` int(11) DEFAULT NULL,
  `monthlyreport_unrecorded_engagements` int(11) DEFAULT NULL,
  `monthlyreport_ministering_disciples` int(11) DEFAULT NULL,
  PRIMARY KEY (`monthlyreport_id`)
) ENGINE=InnoDB AUTO_INCREMENT=508 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_morestats` (
  `morestats_id` int(10) NOT NULL AUTO_INCREMENT,
  `morestats_exp` int(10) NOT NULL DEFAULT '0',
  `morestats_notes` text NOT NULL,
  `week_id` int(10) NOT NULL DEFAULT '0',
  `campus_id` int(10) NOT NULL DEFAULT '0',
  `exposuretype_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`morestats_id`)
) ENGINE=MyISAM AUTO_INCREMENT=579 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_prc` (
  `prc_id` int(10) NOT NULL AUTO_INCREMENT,
  `prc_firstName` varchar(128) NOT NULL DEFAULT '',
  `prcMethod_id` int(10) NOT NULL DEFAULT '0',
  `prc_witnessName` varchar(128) NOT NULL DEFAULT '',
  `semester_id` int(10) NOT NULL DEFAULT '0',
  `campus_id` int(10) NOT NULL DEFAULT '0',
  `prc_notes` text NOT NULL,
  `prc_7upCompleted` int(10) NOT NULL DEFAULT '0',
  `prc_7upStarted` int(10) NOT NULL DEFAULT '0',
  `prc_date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`prc_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1361 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_prcmethod` (
  `prcMethod_id` int(10) NOT NULL AUTO_INCREMENT,
  `prcMethod_desc` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`prcMethod_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_priv` (
  `priv_id` int(16) NOT NULL AUTO_INCREMENT,
  `priv_desc` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`priv_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_semester` (
  `semester_id` int(10) NOT NULL AUTO_INCREMENT,
  `semester_desc` varchar(64) NOT NULL DEFAULT '',
  `semester_startDate` date NOT NULL DEFAULT '0000-00-00',
  `year_id` int(8) NOT NULL DEFAULT '0',
  `translation_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`semester_id`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_semesterreport` (
  `semesterreport_id` int(10) NOT NULL AUTO_INCREMENT,
  `semesterreport_avgPrayer` int(10) NOT NULL DEFAULT '0',
  `semesterreport_avgWklyMtg` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numStaffChall` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numInternChall` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numFrosh` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numStaffDG` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numInStaffDG` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numStudentDG` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numInStudentDG` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numSpMultStaffDG` int(10) NOT NULL DEFAULT '0',
  `semesterreport_numSpMultStdDG` int(10) NOT NULL DEFAULT '0',
  `semester_id` int(10) NOT NULL DEFAULT '0',
  `campus_id` int(10) NOT NULL DEFAULT '0',
  `semesterreport_totalSpMultGradNonMinistry` int(11) DEFAULT '0',
  `semesterreport_totalFullTimeC4cStaff` int(11) DEFAULT '0',
  `semesterreport_totalFullTimeP2cStaffNonC4c` int(11) DEFAULT '0',
  `semesterreport_totalPeopleOneYearInternship` int(11) DEFAULT '0',
  `semesterreport_totalPeopleOtherMinistry` int(11) DEFAULT '0',
  `semesterreport_studentsSummit` int(11) DEFAULT '0',
  `semesterreport_studentsWC` int(11) DEFAULT '0',
  `semesterreport_studentsProjects` int(11) DEFAULT '0',
  `semesterreport_lnz_avgPrayer` int(11) DEFAULT '0',
  `semesterreport_lnz_numFrosh` int(11) DEFAULT '0',
  `semesterreport_lnz_totalStudentInDG` int(11) DEFAULT '0',
  `semesterreport_lnz_totalSpMult` int(11) DEFAULT '0',
  `semesterreport_lnz_totalCoreStudents` int(11) DEFAULT '0',
  `semesterreport_lnz_p2c_numInEvangStudies` int(11) DEFAULT '0',
  `semesterreport_lnz_p2c_numSharingInP2c` int(11) DEFAULT '0',
  `semesterreport_lnz_p2c_numSharingOutP2c` int(11) DEFAULT '0',
  `semesterreport_lnz_ministering_disciples` int(11) DEFAULT '0',
  PRIMARY KEY (`semesterreport_id`)
) ENGINE=MyISAM AUTO_INCREMENT=459 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_week` (
  `week_id` int(50) NOT NULL AUTO_INCREMENT,
  `week_endDate` date NOT NULL DEFAULT '0000-00-00',
  `semester_id` int(16) NOT NULL DEFAULT '0',
  `month_id` int(11) NOT NULL,
  PRIMARY KEY (`week_id`)
) ENGINE=MyISAM AUTO_INCREMENT=539 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_weeklyreport` (
  `weeklyReport_id` int(10) NOT NULL AUTO_INCREMENT,
  `weeklyReport_1on1SpConv` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_1on1GosPres` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_1on1HsPres` int(10) NOT NULL DEFAULT '0',
  `staff_id` int(10) NOT NULL DEFAULT '0',
  `week_id` int(10) NOT NULL DEFAULT '0',
  `campus_id` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_7upCompleted` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_1on1SpConvStd` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_1on1GosPresStd` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_1on1HsPresStd` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_7upCompletedStd` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_cjVideo` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_mda` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_otherEVMats` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_rlk` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_siq` int(10) NOT NULL DEFAULT '0',
  `weeklyReport_notes` text NOT NULL,
  `weeklyReport_p2c_numCommitFilledHS` int(11) DEFAULT '0',
  PRIMARY KEY (`weeklyReport_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11321 DEFAULT CHARSET=latin1;

CREATE TABLE `cim_stats_year` (
  `year_id` int(8) NOT NULL AUTO_INCREMENT,
  `year_desc` varchar(32) NOT NULL DEFAULT '',
  `year_number` int(11) DEFAULT NULL,
  PRIMARY KEY (`year_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

CREATE TABLE `columns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `update_clause` varchar(255) DEFAULT NULL,
  `from_clause` varchar(255) DEFAULT NULL,
  `select_clause` text,
  `column_type` varchar(255) DEFAULT NULL,
  `writeable` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `join_clause` varchar(255) DEFAULT NULL,
  `source_model` varchar(255) DEFAULT NULL,
  `source_column` varchar(255) DEFAULT NULL,
  `foreign_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

CREATE TABLE `conference_registrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conference_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `conferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `mobile_phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `next_step_id` int(11) DEFAULT NULL,
  `what_i_am_trusting_god_to_do_next` text,
  `active` tinyint(1) DEFAULT NULL,
  `private` tinyint(1) DEFAULT '1',
  `campus_id` int(11) DEFAULT NULL,
  `sept_2012_survey_contact_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `gender_id` int(11) DEFAULT '0',
  `international` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_emu.contacts_on_type_and_id` (`type`,`id`),
  KEY `index_emu.contacts_on_first_name` (`first_name`),
  KEY `index_emu.contacts_on_last_name` (`last_name`),
  KEY `index_emu.contacts_on_email` (`email`),
  KEY `index_emu.contacts_on_campus_id` (`campus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1363 DEFAULT CHARSET=utf8;

CREATE TABLE `contacts_people` (
  `person_id` int(11) DEFAULT NULL,
  `contact_id` int(11) DEFAULT NULL,
  KEY `index_emu.contacts_people_on_contact_id` (`contact_id`),
  KEY `index_emu.contacts_people_on_person_id_and_contact_id` (`person_id`,`contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `contract_clauses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `heading` varchar(255) DEFAULT NULL,
  `text` text,
  `checkbox` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;

CREATE TABLE `contract_signatures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `agreement` tinyint(1) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  `signed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_contract_signatures_on_contract_id` (`contract_id`),
  KEY `index_contract_signatures_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2336 DEFAULT CHARSET=utf8;

CREATE TABLE `contracts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `agreement_clause` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `correspondence_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `overdue_lifespan` int(11) DEFAULT NULL,
  `expiry_lifespan` int(11) DEFAULT NULL,
  `actions_now_task` varchar(255) DEFAULT NULL,
  `actions_overdue_task` varchar(255) DEFAULT NULL,
  `actions_followup_task` varchar(255) DEFAULT NULL,
  `redirect_params` text,
  `redirect_target_id_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `correspondences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `correspondence_type_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `receipt` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `visited` date DEFAULT NULL,
  `completed` date DEFAULT NULL,
  `overdue_at` date DEFAULT NULL,
  `expire_at` date DEFAULT NULL,
  `token_params` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_correspondences_on_receipt` (`receipt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `counties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_counties_on_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `is_closed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `custom_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `value_type` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_custom_attributes_on_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `custom_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `custom_attribute_id` int(11) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
  `handler` text,
  `last_error` varchar(255) DEFAULT NULL,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dismissed_notices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `notice_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `dorms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campus_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_dorms_on_campus_id` (`campus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

CREATE TABLE `email_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `correspondence_type_id` int(11) DEFAULT NULL,
  `outcome_type` varchar(255) DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `from` varchar(255) NOT NULL,
  `bcc` varchar(255) DEFAULT NULL,
  `cc` varchar(255) DEFAULT NULL,
  `body` text NOT NULL,
  `template` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) DEFAULT NULL,
  `body` text,
  `people_ids` text,
  `missing_address_ids` text,
  `search_id` int(11) DEFAULT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2074 DEFAULT CHARSET=utf8;

CREATE TABLE `event_attendees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `ticket_id` int(11) DEFAULT NULL,
  `ticket_updated_at` datetime DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `campus` varchar(255) DEFAULT NULL,
  `year_in_school` varchar(255) DEFAULT NULL,
  `home_phone` varchar(255) DEFAULT NULL,
  `cell_phone` varchar(255) DEFAULT NULL,
  `work_phone` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emu.event_attendees_on_event_id` (`event_id`),
  KEY `index_emu.event_attendees_on_ticket_id` (`ticket_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4142 DEFAULT CHARSET=utf8;

CREATE TABLE `event_campuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=965 DEFAULT CHARSET=utf8;

CREATE TABLE `event_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registrar_event_id` bigint(20) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  `register_url` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `synced_at` datetime DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `visible_to_students` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

CREATE TABLE `free_times` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` int(11) DEFAULT NULL,
  `end_time` int(11) DEFAULT NULL,
  `day_of_week` int(11) DEFAULT NULL,
  `timetable_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `css_class` varchar(255) DEFAULT NULL,
  `weight` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `free_times_timetable_id` (`timetable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=393026 DEFAULT CHARSET=utf8;

CREATE TABLE `global_areas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `area` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

CREATE TABLE `global_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `global_area_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `iso3` varchar(255) DEFAULT NULL,
  `stage` int(11) DEFAULT NULL,
  `live_exp` int(11) DEFAULT NULL,
  `live_dec` int(11) DEFAULT NULL,
  `new_grth_mbr` int(11) DEFAULT NULL,
  `mvmt_mbr` int(11) DEFAULT NULL,
  `mvmt_ldr` int(11) DEFAULT NULL,
  `new_staff` int(11) DEFAULT NULL,
  `lifetime_lab` int(11) DEFAULT NULL,
  `virtually_led_live_exp` int(11) DEFAULT NULL,
  `virtually_led_live_dec` int(11) DEFAULT NULL,
  `virtually_led_new_grth_mbr` int(11) DEFAULT NULL,
  `virtually_led_mvmt_mbr` int(11) DEFAULT NULL,
  `virtually_led_mvmt_ldr` int(11) DEFAULT NULL,
  `virtually_led_new_staff` int(11) DEFAULT NULL,
  `virtually_led_lifetime_lab` int(11) DEFAULT NULL,
  `church_led_live_exp` int(11) DEFAULT NULL,
  `church_led_live_dec` int(11) DEFAULT NULL,
  `church_led_new_grth_mbr` int(11) DEFAULT NULL,
  `church_led_mvmt_mbr` int(11) DEFAULT NULL,
  `church_led_mvmt_ldr` int(11) DEFAULT NULL,
  `church_led_new_staff` int(11) DEFAULT NULL,
  `church_led_lifetime_lab` int(11) DEFAULT NULL,
  `leader_led_live_exp` int(11) DEFAULT NULL,
  `leader_led_live_dec` int(11) DEFAULT NULL,
  `leader_led_new_grth_mbr` int(11) DEFAULT NULL,
  `leader_led_mvmt_mbr` int(11) DEFAULT NULL,
  `leader_led_mvmt_ldr` int(11) DEFAULT NULL,
  `leader_led_new_staff` int(11) DEFAULT NULL,
  `leader_led_lifetime_lab` int(11) DEFAULT NULL,
  `student_led_live_exp` int(11) DEFAULT NULL,
  `student_led_live_dec` int(11) DEFAULT NULL,
  `student_led_new_grth_mbr` int(11) DEFAULT NULL,
  `student_led_mvmt_mbr` int(11) DEFAULT NULL,
  `student_led_mvmt_ldr` int(11) DEFAULT NULL,
  `student_led_new_staff` int(11) DEFAULT NULL,
  `student_led_lifetime_lab` int(11) DEFAULT NULL,
  `pop_2010` int(11) DEFAULT NULL,
  `pop_2015` int(11) DEFAULT NULL,
  `pop_2020` int(11) DEFAULT NULL,
  `pop_wfb_gdppp` int(11) DEFAULT NULL,
  `perc_christian` float DEFAULT NULL,
  `perc_evangelical` float DEFAULT NULL,
  `locally_funded_FY10` int(11) DEFAULT NULL,
  `total_income_FY10` int(11) DEFAULT NULL,
  `staff_count_2002` int(11) DEFAULT NULL,
  `staff_count_2009` int(11) DEFAULT NULL,
  `total_students` int(11) DEFAULT NULL,
  `total_schools` int(11) DEFAULT NULL,
  `total_spcs` int(11) DEFAULT NULL,
  `names_priority_spcs` varchar(255) DEFAULT NULL,
  `total_spcs_presence` int(11) DEFAULT NULL,
  `total_spcs_movement` int(11) DEFAULT NULL,
  `total_slm_staff` int(11) DEFAULT NULL,
  `total_new_slm_staff` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=264 DEFAULT CHARSET=utf8;

CREATE TABLE `global_dashboard_accesses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guid` varchar(255) DEFAULT NULL,
  `fn` varchar(255) DEFAULT NULL,
  `ln` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8;

CREATE TABLE `global_dashboard_whq_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mcc` varchar(255) DEFAULT NULL,
  `month_id` int(11) DEFAULT NULL,
  `global_country_id` int(11) DEFAULT NULL,
  `live_exp` int(11) DEFAULT NULL,
  `live_dec` int(11) DEFAULT NULL,
  `new_grth_mbr` int(11) DEFAULT NULL,
  `mvmt_mbr` int(11) DEFAULT NULL,
  `mvmt_ldr` int(11) DEFAULT NULL,
  `new_staff` int(11) DEFAULT NULL,
  `lifetime_lab` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24339 DEFAULT CHARSET=utf8;

CREATE TABLE `global_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gender` varchar(255) DEFAULT NULL,
  `marital_status` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `mission_critical_components` varchar(255) DEFAULT NULL,
  `funding_source` varchar(255) DEFAULT NULL,
  `staff_status` varchar(255) DEFAULT NULL,
  `employment_country` varchar(255) DEFAULT NULL,
  `ministry_location_country` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3669 DEFAULT CHARSET=utf8;

CREATE TABLE `group_invitations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `recipient_email` varchar(255) DEFAULT NULL,
  `recipient_person_id` int(11) DEFAULT NULL,
  `sender_person_id` int(11) DEFAULT NULL,
  `accepted` tinyint(1) DEFAULT NULL,
  `login_code_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emu.group_invitations_on_group_id` (`group_id`),
  KEY `index_emu.group_invitations_on_login_code_id` (`login_code_id`)
) ENGINE=InnoDB AUTO_INCREMENT=633 DEFAULT CHARSET=utf8;

CREATE TABLE `group_involvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `level` varchar(255) DEFAULT NULL,
  `requested` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `person_id_group_id` (`person_id`,`group_id`),
  KEY `index_group_involvements_on_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23151 DEFAULT CHARSET=utf8;

CREATE TABLE `group_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `group_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `mentor_priority` tinyint(1) DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL,
  `unsuitability_leader` int(11) DEFAULT NULL,
  `unsuitability_coleader` int(11) DEFAULT NULL,
  `unsuitability_participant` int(11) DEFAULT NULL,
  `collection_group_name` varchar(255) DEFAULT '{{campus}} interested in a {{group_type}}',
  `has_collection_groups` tinyint(1) DEFAULT '0',
  `in_directory_search_not_in` tinyint(1) DEFAULT '0',
  `short_name` varchar(255) DEFAULT NULL,
  `in_directory_search_in` tinyint(1) DEFAULT '0',
  `translation_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `address_2` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `dorm_id` int(11) DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  `start_time` int(11) DEFAULT NULL,
  `end_time` int(11) DEFAULT NULL,
  `day` int(11) DEFAULT NULL,
  `group_type_id` int(11) DEFAULT NULL,
  `needs_approval` tinyint(1) DEFAULT NULL,
  `semester_id` int(11) DEFAULT NULL,
  `show_group_info` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_groups_on_campus_id` (`campus_id`),
  KEY `index_groups_on_dorm_id` (`dorm_id`),
  KEY `index_groups_on_ministry_id` (`ministry_id`),
  KEY `index_emu.groups_on_semester_id` (`semester_id`),
  KEY `index_emu.groups_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2840 DEFAULT CHARSET=utf8;

CREATE TABLE `imports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `involvement_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  `school_year_id` int(11) DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  `ministry_role_id` int(11) DEFAULT NULL,
  `campus_involvement_id` int(11) DEFAULT NULL,
  `ministry_involvement_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4504 DEFAULT CHARSET=utf8;

CREATE TABLE `label_people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emu.label_people_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=376 DEFAULT CHARSET=utf8;

CREATE TABLE `labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) DEFAULT NULL,
  `priority` int(11) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `locks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `locked` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `login_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acceptable` tinyint(1) DEFAULT '1',
  `times_used` int(11) DEFAULT '0',
  `code` varchar(255) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emu.login_codes_on_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=13162 DEFAULT CHARSET=utf8;

CREATE TABLE `merges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `keep_person_id` int(11) DEFAULT NULL,
  `keep_viewer_id` int(11) DEFAULT NULL,
  `other_person_id` int(11) DEFAULT NULL,
  `other_viewer_id` int(11) DEFAULT NULL,
  `success` tinyint(1) DEFAULT NULL,
  `error_message` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sql_error` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `ministries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  `updated_at` date DEFAULT NULL,
  `ministries_count` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ministries_on_parent_id` (`parent_id`),
  KEY `index_emu.ministries_on_lft` (`lft`),
  KEY `index_emu.ministries_on_rgt` (`rgt`),
  KEY `index_emu.ministries_on_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_campuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ministry_campuses_on_ministry_id_and_campus_id` (`ministry_id`,`campus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_involvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `admin` tinyint(1) DEFAULT NULL,
  `ministry_role_id` int(11) DEFAULT NULL,
  `responsible_person_id` int(11) DEFAULT NULL,
  `last_history_update_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ministry_involvements_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14514 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_role_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_id` int(11) DEFAULT NULL,
  `ministry_role_id` int(11) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=792 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `involved` tinyint(1) DEFAULT NULL,
  `translation_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ministry_roles_on_ministry_id` (`ministry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

CREATE TABLE `multi_gen_buttons` (
  `button_id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT '0',
  `button_key` varchar(50) NOT NULL DEFAULT '',
  `button_value` varchar(50) NOT NULL DEFAULT '',
  `language_id` int(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`button_id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

CREATE TABLE `multi_labels` (
  `labels_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL DEFAULT '0',
  `language_id` int(4) NOT NULL DEFAULT '0',
  `labels_key` varchar(50) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `labels_label` text CHARACTER SET latin1 NOT NULL,
  `labels_caption` text CHARACTER SET latin1,
  PRIMARY KEY (`labels_id`),
  KEY `page_id` (`page_id`),
  KEY `language_id` (`language_id`)
) ENGINE=MyISAM AUTO_INCREMENT=26304 DEFAULT CHARSET=utf8;

CREATE TABLE `multi_languages` (
  `language_id` int(11) NOT NULL AUTO_INCREMENT,
  `language_label` varchar(128) NOT NULL DEFAULT '',
  `labels_key` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`language_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `multi_page` (
  `page_id` int(11) NOT NULL AUTO_INCREMENT,
  `series_id` int(11) NOT NULL DEFAULT '0',
  `page_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1685 DEFAULT CHARSET=latin1;

CREATE TABLE `multi_series` (
  `series_id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT '0',
  `series_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`series_id`)
) ENGINE=MyISAM AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;

CREATE TABLE `multi_site` (
  `site_id` int(11) NOT NULL AUTO_INCREMENT,
  `site_label` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`site_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `national_day` (
  `day_id` int(11) NOT NULL AUTO_INCREMENT,
  `day_date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`day_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2018 DEFAULT CHARSET=latin1;

CREATE TABLE `national_signup` (
  `signup_id` int(11) NOT NULL AUTO_INCREMENT,
  `day_id` int(11) NOT NULL DEFAULT '0',
  `time_id` int(11) NOT NULL DEFAULT '0',
  `signup_name` varchar(128) NOT NULL DEFAULT '',
  `campus_id` int(11) NOT NULL DEFAULT '0',
  `signup_email` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`signup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5145 DEFAULT CHARSET=latin1;

CREATE TABLE `national_time` (
  `time_id` int(11) NOT NULL AUTO_INCREMENT,
  `time_time` time NOT NULL DEFAULT '00:00:00',
  PRIMARY KEY (`time_id`)
) ENGINE=MyISAM AUTO_INCREMENT=241 DEFAULT CHARSET=latin1;

CREATE TABLE `national_timezones` (
  `timezones_id` int(11) NOT NULL AUTO_INCREMENT,
  `timezones_desc` varchar(32) NOT NULL DEFAULT '',
  `timezones_offset` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`timezones_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `navbar_navbarcache` (
  `navbarcache_id` int(11) NOT NULL AUTO_INCREMENT,
  `viewer_id` int(11) NOT NULL DEFAULT '0',
  `language_id` int(11) NOT NULL DEFAULT '0',
  `navbarcache_cache` text NOT NULL,
  `navbarcache_isValid` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`navbarcache_id`)
) ENGINE=MyISAM AUTO_INCREMENT=146533 DEFAULT CHARSET=latin1;

CREATE TABLE `navbar_navbargroup` (
  `navbargroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `navbargroup_nameKey` varchar(50) NOT NULL DEFAULT '',
  `navbargroup_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`navbargroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

CREATE TABLE `navbar_navbarlinks` (
  `navbarlink_id` int(11) NOT NULL AUTO_INCREMENT,
  `navbargroup_id` int(11) NOT NULL DEFAULT '0',
  `navbarlink_textKey` varchar(50) NOT NULL DEFAULT '',
  `navbarlink_url` text NOT NULL,
  `module_id` int(11) NOT NULL DEFAULT '0',
  `navbarlink_isActive` int(1) NOT NULL DEFAULT '0',
  `navbarlink_isModule` int(1) NOT NULL DEFAULT '0',
  `navbarlink_order` int(11) NOT NULL DEFAULT '0',
  `navbarlink_startDateTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `navbarlink_endDateTime` datetime NOT NULL DEFAULT '9999-12-29 23:59:00',
  PRIMARY KEY (`navbarlink_id`)
) ENGINE=MyISAM AUTO_INCREMENT=72 DEFAULT CHARSET=latin1;

CREATE TABLE `navbar_navlinkaccessgroup` (
  `navlinkaccessgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `navbarlink_id` int(11) NOT NULL DEFAULT '0',
  `accessgroup_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`navlinkaccessgroup_id`)
) ENGINE=MyISAM AUTO_INCREMENT=111 DEFAULT CHARSET=latin1;

CREATE TABLE `navbar_navlinkviewer` (
  `navlinkviewer_id` int(11) NOT NULL AUTO_INCREMENT,
  `navbarlink_id` int(11) NOT NULL DEFAULT '0',
  `viewer_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`navlinkviewer_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `noteable_type` varchar(255) DEFAULT NULL,
  `noteable_id` int(11) DEFAULT NULL,
  `content` text,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notes_on_noteable_type_and_noteable_id` (`noteable_type`,`noteable_id`),
  KEY `index_notes_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4894 DEFAULT CHARSET=utf8;

CREATE TABLE `notices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text,
  `live` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notices_on_live` (`live`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `middle_name` varchar(255) DEFAULT NULL,
  `preferred_name` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `year_in_school` varchar(255) DEFAULT NULL,
  `level_of_school` varchar(255) DEFAULT NULL,
  `graduation_date` date DEFAULT NULL,
  `major` varchar(255) DEFAULT NULL,
  `minor` varchar(255) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `bio` text,
  `image` varchar(255) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  `updated_at` date DEFAULT NULL,
  `staff_notes` varchar(255) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `url` varchar(2000) DEFAULT NULL,
  `primary_campus_involvement_id` int(11) DEFAULT NULL,
  `mentor_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_people_on_user_id` (`user_id`),
  KEY `index_people_on_first_name` (`first_name`),
  KEY `index_people_on_last_name_and_first_name` (`last_name`,`first_name`),
  KEY `index_people_on_major_and_minor` (`major`,`minor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(1000) DEFAULT NULL,
  `controller` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_permissions_on_controller_and_action` (`controller`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=utf8;

CREATE TABLE `person_event_attendees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `event_attendee_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emu.person_event_attendees_on_person_id` (`person_id`),
  KEY `index_emu.person_event_attendees_on_event_attendee_id` (`event_attendee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3204 DEFAULT CHARSET=utf8;

CREATE TABLE `person_extras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `major` varchar(255) DEFAULT NULL,
  `minor` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `staff_notes` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `perm_start_date` date DEFAULT NULL,
  `perm_end_date` date DEFAULT NULL,
  `perm_dorm` varchar(255) DEFAULT NULL,
  `perm_room` varchar(255) DEFAULT NULL,
  `perm_alternate_phone` varchar(255) DEFAULT NULL,
  `curr_start_date` date DEFAULT NULL,
  `curr_end_date` date DEFAULT NULL,
  `curr_dorm` varchar(255) DEFAULT NULL,
  `curr_room` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_person_extras_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21176 DEFAULT CHARSET=utf8;

CREATE TABLE `person_training_courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `training_course_id` int(11) DEFAULT NULL,
  `finished` tinyint(1) DEFAULT NULL,
  `percent_complete` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_person_training_courses_on_person_id` (`person_id`),
  KEY `index_person_training_courses_on_training_course_id` (`training_course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1620 DEFAULT CHARSET=utf8;

CREATE TABLE `profile_pictures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `uploaded_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1805 DEFAULT CHARSET=utf8;

CREATE TABLE `rad_dafield` (
  `dafield_id` int(11) NOT NULL AUTO_INCREMENT,
  `daobj_id` int(11) NOT NULL DEFAULT '0',
  `statevar_id` int(11) NOT NULL DEFAULT '-1',
  `dafield_name` varchar(50) NOT NULL DEFAULT '',
  `dafield_desc` text NOT NULL,
  `dafield_type` varchar(50) NOT NULL DEFAULT '',
  `dafield_dbType` varchar(50) NOT NULL DEFAULT '',
  `dafield_formFieldType` varchar(50) NOT NULL DEFAULT '',
  `dafield_isPrimaryKey` int(1) NOT NULL DEFAULT '0',
  `dafield_isForeignKey` int(1) NOT NULL DEFAULT '0',
  `dafield_isNullable` int(1) NOT NULL DEFAULT '0',
  `dafield_default` varchar(50) NOT NULL DEFAULT '',
  `dafield_invalidValue` varchar(50) NOT NULL DEFAULT '',
  `dafield_isLabelName` int(1) NOT NULL DEFAULT '0',
  `dafield_isListInit` int(1) NOT NULL DEFAULT '0',
  `dafield_isCreated` int(1) NOT NULL DEFAULT '0',
  `dafield_title` text NOT NULL,
  `dafield_formLabel` text NOT NULL,
  `dafield_example` text NOT NULL,
  `dafield_error` text NOT NULL,
  PRIMARY KEY (`dafield_id`)
) ENGINE=MyISAM AUTO_INCREMENT=359 DEFAULT CHARSET=latin1;

CREATE TABLE `rad_daobj` (
  `daobj_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) NOT NULL DEFAULT '0',
  `daobj_name` varchar(50) NOT NULL DEFAULT '',
  `daobj_desc` text NOT NULL,
  `daobj_dbTableName` varchar(100) NOT NULL DEFAULT '',
  `daobj_managerInitVarID` int(11) NOT NULL DEFAULT '0',
  `daobj_listInitVarID` int(11) NOT NULL DEFAULT '0',
  `daobj_isCreated` int(1) NOT NULL DEFAULT '0',
  `daobj_isUpdated` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`daobj_id`)
) ENGINE=MyISAM AUTO_INCREMENT=81 DEFAULT CHARSET=latin1;

CREATE TABLE `rad_module` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_name` varchar(50) NOT NULL DEFAULT '',
  `module_desc` text NOT NULL,
  `module_creatorName` text NOT NULL,
  `module_isCommonLook` int(1) NOT NULL DEFAULT '0',
  `module_isCore` int(1) NOT NULL DEFAULT '0',
  `module_isCreated` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`module_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

CREATE TABLE `rad_page` (
  `page_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) NOT NULL DEFAULT '0',
  `page_name` varchar(50) NOT NULL DEFAULT '',
  `page_desc` text NOT NULL,
  `page_type` varchar(5) NOT NULL DEFAULT '',
  `page_isAdd` int(1) NOT NULL DEFAULT '0',
  `page_rowMgrID` int(11) NOT NULL DEFAULT '0',
  `page_listMgrID` int(11) NOT NULL DEFAULT '0',
  `page_isCreated` int(1) NOT NULL DEFAULT '0',
  `page_isDefault` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=123 DEFAULT CHARSET=latin1;

CREATE TABLE `rad_pagefield` (
  `pagefield_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL DEFAULT '0',
  `daobj_id` int(11) NOT NULL DEFAULT '0',
  `dafield_id` int(11) NOT NULL DEFAULT '0',
  `pagefield_isForm` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pagefield_id`)
) ENGINE=MyISAM AUTO_INCREMENT=433 DEFAULT CHARSET=latin1;

CREATE TABLE `rad_pagelabels` (
  `pagelabel_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL DEFAULT '0',
  `pagelabel_key` varchar(50) NOT NULL DEFAULT '',
  `pagelabel_label` text NOT NULL,
  `language_id` int(11) NOT NULL DEFAULT '0',
  `pagelabel_isCreated` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pagelabel_id`)
) ENGINE=MyISAM AUTO_INCREMENT=186 DEFAULT CHARSET=latin1;

CREATE TABLE `rad_statevar` (
  `statevar_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) NOT NULL DEFAULT '0',
  `statevar_name` varchar(50) NOT NULL DEFAULT '',
  `statevar_desc` text NOT NULL,
  `statevar_type` enum('STRING','BOOL','INTEGER','DATE') NOT NULL DEFAULT 'STRING',
  `statevar_default` varchar(50) NOT NULL DEFAULT '',
  `statevar_isCreated` int(1) NOT NULL DEFAULT '0',
  `statevar_isUpdated` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`statevar_id`)
) ENGINE=MyISAM AUTO_INCREMENT=97 DEFAULT CHARSET=latin1;

CREATE TABLE `rad_transitions` (
  `transition_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) NOT NULL DEFAULT '0',
  `transition_fromObjID` int(11) NOT NULL DEFAULT '0',
  `transition_toObjID` int(11) NOT NULL DEFAULT '0',
  `transition_type` varchar(10) NOT NULL DEFAULT '',
  `transition_isCreated` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`transition_id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=latin1;

CREATE TABLE `recruitments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `recruiter_id` int(11) DEFAULT NULL,
  `status_id` int(11) DEFAULT NULL,
  `interested_in_field_staff` tinyint(1) DEFAULT NULL,
  `interested_in_international_field_staff` tinyint(1) DEFAULT NULL,
  `interested_in_creative_communications` tinyint(1) DEFAULT NULL,
  `interested_in_francophone_ministry` tinyint(1) DEFAULT NULL,
  `interested_in_expansion_team` tinyint(1) DEFAULT NULL,
  `interested_in_global_impact_team` tinyint(1) DEFAULT NULL,
  `interested_in_student_hq` tinyint(1) DEFAULT NULL,
  `interested_in_hq` tinyint(1) DEFAULT NULL,
  `interested_in_other` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `school_years` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `level` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `searches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `options` text,
  `query` text,
  `tables` text,
  `saved` tinyint(1) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `order` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `tables_clause` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12153 DEFAULT CHARSET=utf8;

CREATE TABLE `sept2012_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `connect_id` int(11) DEFAULT NULL,
  `missionHub_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `cellphone` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `result` int(11) DEFAULT '0',
  `nextStep` int(11) DEFAULT '0',
  `priority` varchar(255) DEFAULT NULL,
  `gender_id` int(11) DEFAULT NULL,
  `year` varchar(255) DEFAULT NULL,
  `degree` varchar(255) DEFAULT NULL,
  `residence` varchar(255) DEFAULT NULL,
  `international` int(11) DEFAULT '0',
  `craving` varchar(255) DEFAULT NULL,
  `magazine` varchar(255) DEFAULT NULL,
  `journey` varchar(255) DEFAULT NULL,
  `interest` int(11) DEFAULT '0',
  `person_id` int(11) DEFAULT NULL,
  `data_input_notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sept2012_contacts_on_campus_id` (`campus_id`),
  KEY `index_sept2012_contacts_on_gender_id` (`gender_id`),
  KEY `index_sept2012_contacts_on_person_id` (`person_id`),
  KEY `index_sept2012_contacts_on_priority` (`priority`),
  KEY `index_sept2012_contacts_on_status` (`status`),
  KEY `index_sept2012_contacts_on_result` (`result`),
  KEY `index_sept2012_contacts_on_degree` (`degree`),
  KEY `index_sept2012_contacts_on_international` (`international`)
) ENGINE=InnoDB AUTO_INCREMENT=25145 DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=889959 DEFAULT CHARSET=utf8;

CREATE TABLE `site_logmanager` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `log_userID` varchar(50) NOT NULL DEFAULT '',
  `log_dateTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `log_recipientID` varchar(50) NOT NULL DEFAULT '',
  `log_description` text NOT NULL,
  `log_data` text NOT NULL,
  `log_viewerIP` varchar(15) NOT NULL DEFAULT '',
  `log_applicationKey` varchar(4) NOT NULL DEFAULT '',
  PRIMARY KEY (`log_id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

CREATE TABLE `site_multilingual_label` (
  `label_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL DEFAULT '0',
  `label_key` varchar(50) NOT NULL DEFAULT '',
  `label_label` text NOT NULL,
  `label_moddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `language_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`label_id`),
  KEY `ciministry.site_multilingual_label_page_id_index` (`page_id`),
  KEY `ciministry.site_multilingual_label_label_key_index` (`label_key`),
  KEY `ciministry.site_multilingual_label_language_id_index` (`language_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4646 DEFAULT CHARSET=latin1;

CREATE TABLE `site_multilingual_page` (
  `page_id` int(11) NOT NULL AUTO_INCREMENT,
  `series_id` int(11) NOT NULL DEFAULT '0',
  `page_key` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=304 DEFAULT CHARSET=latin1;

CREATE TABLE `site_multilingual_series` (
  `series_id` int(11) NOT NULL AUTO_INCREMENT,
  `series_key` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`series_id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

CREATE TABLE `site_multilingual_xlation` (
  `xlation_id` int(11) NOT NULL AUTO_INCREMENT,
  `label_id` int(11) NOT NULL DEFAULT '0',
  `language_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`xlation_id`),
  KEY `language_id` (`language_id`),
  KEY `label_id` (`label_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5548 DEFAULT CHARSET=latin1;

CREATE TABLE `site_page_modules` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_key` varchar(50) NOT NULL DEFAULT '',
  `module_path` text NOT NULL,
  `module_app` varchar(50) NOT NULL DEFAULT '',
  `module_include` varchar(50) NOT NULL DEFAULT '',
  `module_name` varchar(50) NOT NULL DEFAULT '',
  `module_parameters` text NOT NULL,
  `module_systemAccessFile` varchar(50) NOT NULL DEFAULT '',
  `module_systemAccessObj` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`module_id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;

CREATE TABLE `site_session` (
  `session_id` varchar(32) NOT NULL DEFAULT '',
  `session_data` text NOT NULL,
  `session_expiration` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_staff_on_ministry_id` (`ministry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `abbreviation` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `stint_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stint_location_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `stint_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `strategies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `abbrv` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `summer_project_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `summer_project_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `summer_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `summer_report_assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assignment` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

CREATE TABLE `summer_report_reviewers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `summer_report_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `reviewed` tinyint(1) DEFAULT NULL,
  `approved` tinyint(1) DEFAULT NULL,
  `review_notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=latin1;

CREATE TABLE `summer_report_weeks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `summer_report_id` int(11) DEFAULT NULL,
  `week_id` int(11) DEFAULT NULL,
  `summer_report_assignment_id` int(11) DEFAULT NULL,
  `description` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2953 DEFAULT CHARSET=latin1;

CREATE TABLE `summer_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `year_id` int(11) DEFAULT NULL,
  `joined_staff` varchar(255) DEFAULT NULL,
  `days_of_holiday` varchar(255) DEFAULT NULL,
  `monthly_goal` varchar(255) DEFAULT NULL,
  `monthly_have` varchar(255) DEFAULT NULL,
  `monthly_needed` varchar(255) DEFAULT NULL,
  `num_weeks_of_mpd` int(11) DEFAULT NULL,
  `num_weeks_of_mpm` int(11) DEFAULT NULL,
  `support_coach` tinyint(1) DEFAULT NULL,
  `accountability_partner` varchar(255) DEFAULT NULL,
  `notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=latin1;

CREATE TABLE `temp_group_involvements` (
  `person_id` int(11) DEFAULT NULL,
  `group_involvements` varchar(255) DEFAULT NULL,
  KEY `index_temp_group_involvements_on_person_id` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `temp_mb_early_frosh` (
  `registration_id` int(10) NOT NULL,
  PRIMARY KEY (`registration_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

CREATE TABLE `timetables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by_person_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emu.timetables_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9533 DEFAULT CHARSET=utf8;

CREATE TABLE `training_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `training_question_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `completed_at` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `approved_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `training_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `training_courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;

CREATE TABLE `training_question_activations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `training_question_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `mandate` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `training_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity` varchar(255) DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `training_category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `pass` blob,
  `click_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `login_code_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_codes_on_user_id` (`user_id`),
  KEY `index_emu.user_codes_on_login_code_id` (`login_code_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12526 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `system_admin` tinyint(1) DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `guid` varchar(255) DEFAULT NULL,
  `email_validated` tinyint(1) DEFAULT NULL,
  `developer` tinyint(1) DEFAULT NULL,
  `facebook_hash` varchar(255) DEFAULT NULL,
  `facebook_username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `view_columns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `view_id` varchar(255) DEFAULT NULL,
  `column_id` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `view_columns_column_id` (`column_id`,`view_id`),
  KEY `index_view_columns_on_view_id` (`view_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1951 DEFAULT CHARSET=utf8;

CREATE TABLE `views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `ministry_id` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `default_view` tinyint(1) DEFAULT NULL,
  `select_clause` varchar(2000) DEFAULT NULL,
  `tables_clause` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=287 DEFAULT CHARSET=utf8;

CREATE TABLE `wp_comments` (
  `comment_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_post_ID` int(11) NOT NULL DEFAULT '0',
  `comment_author` tinytext NOT NULL,
  `comment_author_email` varchar(100) NOT NULL DEFAULT '',
  `comment_author_url` varchar(200) NOT NULL DEFAULT '',
  `comment_author_IP` varchar(100) NOT NULL DEFAULT '',
  `comment_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_content` text NOT NULL,
  `comment_karma` int(11) NOT NULL DEFAULT '0',
  `comment_approved` varchar(20) NOT NULL DEFAULT '1',
  `comment_agent` varchar(255) NOT NULL DEFAULT '',
  `comment_type` varchar(20) NOT NULL DEFAULT '',
  `comment_parent` bigint(20) NOT NULL DEFAULT '0',
  `user_id` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`comment_ID`),
  KEY `comment_approved` (`comment_approved`),
  KEY `comment_post_ID` (`comment_post_ID`),
  KEY `comment_approved_date_gmt` (`comment_approved`,`comment_date_gmt`),
  KEY `comment_date_gmt` (`comment_date_gmt`)
) ENGINE=MyISAM AUTO_INCREMENT=40641 DEFAULT CHARSET=utf8;

CREATE TABLE `wp_formbuilder_fields` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `form_id` bigint(20) NOT NULL,
  `display_order` int(11) NOT NULL,
  `field_type` varchar(255) NOT NULL,
  `field_name` varchar(255) NOT NULL,
  `field_value` blob NOT NULL,
  `field_label` blob NOT NULL,
  `required_data` varchar(255) NOT NULL,
  `error_message` blob NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=59 DEFAULT CHARSET=latin1;

CREATE TABLE `wp_formbuilder_forms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` blob NOT NULL,
  `subject` blob NOT NULL,
  `recipient` blob NOT NULL,
  `method` enum('POST','GET') NOT NULL,
  `action` varchar(255) NOT NULL,
  `thankyoutext` blob NOT NULL,
  `autoresponse` bigint(20) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

CREATE TABLE `wp_formbuilder_pages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL,
  `form_id` bigint(20) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

CREATE TABLE `wp_formbuilder_responses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` blob NOT NULL,
  `subject` blob NOT NULL,
  `message` blob NOT NULL,
  `from_name` blob NOT NULL,
  `from_email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `wp_links` (
  `link_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `link_url` varchar(255) NOT NULL DEFAULT '',
  `link_name` varchar(255) NOT NULL DEFAULT '',
  `link_image` varchar(255) NOT NULL DEFAULT '',
  `link_target` varchar(25) NOT NULL DEFAULT '',
  `link_category` bigint(20) NOT NULL DEFAULT '0',
  `link_description` varchar(255) NOT NULL DEFAULT '',
  `link_visible` varchar(20) NOT NULL DEFAULT 'Y',
  `link_owner` int(11) NOT NULL DEFAULT '1',
  `link_rating` int(11) NOT NULL DEFAULT '0',
  `link_updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_rel` varchar(255) NOT NULL DEFAULT '',
  `link_notes` mediumtext NOT NULL,
  `link_rss` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`link_id`),
  KEY `link_category` (`link_category`),
  KEY `link_visible` (`link_visible`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `wp_options` (
  `option_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `blog_id` int(11) NOT NULL DEFAULT '0',
  `option_name` varchar(64) NOT NULL DEFAULT '',
  `option_value` longtext NOT NULL,
  `autoload` varchar(20) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`option_id`,`blog_id`,`option_name`),
  KEY `option_name` (`option_name`)
) ENGINE=MyISAM AUTO_INCREMENT=381 DEFAULT CHARSET=utf8;

CREATE TABLE `wp_postmeta` (
  `meta_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL DEFAULT '0',
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext,
  PRIMARY KEY (`meta_id`),
  KEY `post_id` (`post_id`),
  KEY `meta_key` (`meta_key`)
) ENGINE=MyISAM AUTO_INCREMENT=119 DEFAULT CHARSET=utf8;

CREATE TABLE `wp_posts` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) NOT NULL DEFAULT '0',
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext NOT NULL,
  `post_title` text NOT NULL,
  `post_category` int(4) NOT NULL DEFAULT '0',
  `post_excerpt` text NOT NULL,
  `post_status` varchar(20) NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) NOT NULL DEFAULT 'open',
  `post_password` varchar(20) NOT NULL DEFAULT '',
  `post_name` varchar(200) NOT NULL DEFAULT '',
  `to_ping` text NOT NULL,
  `pinged` text NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` text NOT NULL,
  `post_parent` bigint(20) NOT NULL DEFAULT '0',
  `guid` varchar(255) NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT '0',
  `post_type` varchar(20) NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`)
) ENGINE=MyISAM AUTO_INCREMENT=209 DEFAULT CHARSET=utf8;

CREATE TABLE `wp_term_relationships` (
  `object_id` bigint(20) NOT NULL DEFAULT '0',
  `term_taxonomy_id` bigint(20) NOT NULL DEFAULT '0',
  `term_order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`,`term_taxonomy_id`),
  KEY `term_taxonomy_id` (`term_taxonomy_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `wp_term_taxonomy` (
  `term_taxonomy_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) NOT NULL DEFAULT '0',
  `taxonomy` varchar(32) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `parent` bigint(20) NOT NULL DEFAULT '0',
  `count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_taxonomy_id`),
  UNIQUE KEY `term_id_taxonomy` (`term_id`,`taxonomy`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `wp_terms` (
  `term_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `slug` varchar(200) NOT NULL DEFAULT '',
  `term_group` bigint(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `wp_usermeta` (
  `umeta_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL DEFAULT '0',
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext,
  PRIMARY KEY (`umeta_id`),
  KEY `user_id` (`user_id`),
  KEY `meta_key` (`meta_key`)
) ENGINE=MyISAM AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;

CREATE TABLE `wp_users` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) NOT NULL DEFAULT '',
  `user_pass` varchar(64) NOT NULL DEFAULT '',
  `user_nicename` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(100) NOT NULL DEFAULT '',
  `user_url` varchar(100) NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(60) NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT '0',
  `display_name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `user_login_key` (`user_login`),
  KEY `user_nicename` (`user_nicename`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('14');

INSERT INTO schema_migrations (version) VALUES ('15');

INSERT INTO schema_migrations (version) VALUES ('16');

INSERT INTO schema_migrations (version) VALUES ('17');

INSERT INTO schema_migrations (version) VALUES ('18');

INSERT INTO schema_migrations (version) VALUES ('19');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20');

INSERT INTO schema_migrations (version) VALUES ('20080828001540');

INSERT INTO schema_migrations (version) VALUES ('20081005163735');

INSERT INTO schema_migrations (version) VALUES ('20081020192721');

INSERT INTO schema_migrations (version) VALUES ('20081025172521');

INSERT INTO schema_migrations (version) VALUES ('20081026195816');

INSERT INTO schema_migrations (version) VALUES ('20081030025345');

INSERT INTO schema_migrations (version) VALUES ('20081103133213');

INSERT INTO schema_migrations (version) VALUES ('20081103180722');

INSERT INTO schema_migrations (version) VALUES ('20081104201845');

INSERT INTO schema_migrations (version) VALUES ('20081104222308');

INSERT INTO schema_migrations (version) VALUES ('20081121183313');

INSERT INTO schema_migrations (version) VALUES ('20081128204123');

INSERT INTO schema_migrations (version) VALUES ('20081129173725');

INSERT INTO schema_migrations (version) VALUES ('20081130220230');

INSERT INTO schema_migrations (version) VALUES ('20081204143200');

INSERT INTO schema_migrations (version) VALUES ('20081211175127');

INSERT INTO schema_migrations (version) VALUES ('20090115054530');

INSERT INTO schema_migrations (version) VALUES ('20090115210516');

INSERT INTO schema_migrations (version) VALUES ('20090121064613');

INSERT INTO schema_migrations (version) VALUES ('20090125143621');

INSERT INTO schema_migrations (version) VALUES ('20090221002300');

INSERT INTO schema_migrations (version) VALUES ('20090307210953');

INSERT INTO schema_migrations (version) VALUES ('20090311214128');

INSERT INTO schema_migrations (version) VALUES ('20090311222547');

INSERT INTO schema_migrations (version) VALUES ('20090312181338');

INSERT INTO schema_migrations (version) VALUES ('20090314160603');

INSERT INTO schema_migrations (version) VALUES ('20090317172625');

INSERT INTO schema_migrations (version) VALUES ('20090406070216');

INSERT INTO schema_migrations (version) VALUES ('20090406233638');

INSERT INTO schema_migrations (version) VALUES ('20090406233844');

INSERT INTO schema_migrations (version) VALUES ('20090525161157');

INSERT INTO schema_migrations (version) VALUES ('20090525162032');

INSERT INTO schema_migrations (version) VALUES ('20090527204044');

INSERT INTO schema_migrations (version) VALUES ('20090527204518');

INSERT INTO schema_migrations (version) VALUES ('20090528154909');

INSERT INTO schema_migrations (version) VALUES ('20090529184914');

INSERT INTO schema_migrations (version) VALUES ('20090530004946');

INSERT INTO schema_migrations (version) VALUES ('20090530213247');

INSERT INTO schema_migrations (version) VALUES ('20090531224945');

INSERT INTO schema_migrations (version) VALUES ('20090602030150');

INSERT INTO schema_migrations (version) VALUES ('20090604184951');

INSERT INTO schema_migrations (version) VALUES ('20090609044144');

INSERT INTO schema_migrations (version) VALUES ('20090726200034');

INSERT INTO schema_migrations (version) VALUES ('20090811190042');

INSERT INTO schema_migrations (version) VALUES ('20090813162637');

INSERT INTO schema_migrations (version) VALUES ('20090923163810');

INSERT INTO schema_migrations (version) VALUES ('20091004205424');

INSERT INTO schema_migrations (version) VALUES ('20091007141651');

INSERT INTO schema_migrations (version) VALUES ('20091012000730');

INSERT INTO schema_migrations (version) VALUES ('20091027033604');

INSERT INTO schema_migrations (version) VALUES ('20091027033704');

INSERT INTO schema_migrations (version) VALUES ('20091103202343');

INSERT INTO schema_migrations (version) VALUES ('20091104204904');

INSERT INTO schema_migrations (version) VALUES ('20091231214211');

INSERT INTO schema_migrations (version) VALUES ('20100109055730');

INSERT INTO schema_migrations (version) VALUES ('20100125204611');

INSERT INTO schema_migrations (version) VALUES ('20100125211110');

INSERT INTO schema_migrations (version) VALUES ('20100210202651');

INSERT INTO schema_migrations (version) VALUES ('20100303202104');

INSERT INTO schema_migrations (version) VALUES ('20100407173131');

INSERT INTO schema_migrations (version) VALUES ('20100505172935');

INSERT INTO schema_migrations (version) VALUES ('20100507153429');

INSERT INTO schema_migrations (version) VALUES ('20100507153649');

INSERT INTO schema_migrations (version) VALUES ('20100507173839');

INSERT INTO schema_migrations (version) VALUES ('20100507195259');

INSERT INTO schema_migrations (version) VALUES ('20100513181447');

INSERT INTO schema_migrations (version) VALUES ('20100514183003');

INSERT INTO schema_migrations (version) VALUES ('20100518022822');

INSERT INTO schema_migrations (version) VALUES ('20100518023034');

INSERT INTO schema_migrations (version) VALUES ('20100519193415');

INSERT INTO schema_migrations (version) VALUES ('20100519193647');

INSERT INTO schema_migrations (version) VALUES ('20100519224300');

INSERT INTO schema_migrations (version) VALUES ('20100521194550');

INSERT INTO schema_migrations (version) VALUES ('20100526141633');

INSERT INTO schema_migrations (version) VALUES ('20100601192910');

INSERT INTO schema_migrations (version) VALUES ('20100608205353');

INSERT INTO schema_migrations (version) VALUES ('20100611162109');

INSERT INTO schema_migrations (version) VALUES ('20100614175935');

INSERT INTO schema_migrations (version) VALUES ('20100614182328');

INSERT INTO schema_migrations (version) VALUES ('20100616160610');

INSERT INTO schema_migrations (version) VALUES ('20100617184410');

INSERT INTO schema_migrations (version) VALUES ('20100617184454');

INSERT INTO schema_migrations (version) VALUES ('20100617191312');

INSERT INTO schema_migrations (version) VALUES ('20100617225456');

INSERT INTO schema_migrations (version) VALUES ('20100618143651');

INSERT INTO schema_migrations (version) VALUES ('20100621144706');

INSERT INTO schema_migrations (version) VALUES ('20100621145448');

INSERT INTO schema_migrations (version) VALUES ('20100621152418');

INSERT INTO schema_migrations (version) VALUES ('20100621152430');

INSERT INTO schema_migrations (version) VALUES ('20100624184736');

INSERT INTO schema_migrations (version) VALUES ('20100628192154');

INSERT INTO schema_migrations (version) VALUES ('20100629185606');

INSERT INTO schema_migrations (version) VALUES ('20100630042925');

INSERT INTO schema_migrations (version) VALUES ('20100630182603');

INSERT INTO schema_migrations (version) VALUES ('20100708032653');

INSERT INTO schema_migrations (version) VALUES ('20100803212400');

INSERT INTO schema_migrations (version) VALUES ('20100803213906');

INSERT INTO schema_migrations (version) VALUES ('20100816023643');

INSERT INTO schema_migrations (version) VALUES ('20100816130327');

INSERT INTO schema_migrations (version) VALUES ('20100818015210');

INSERT INTO schema_migrations (version) VALUES ('20100818015834');

INSERT INTO schema_migrations (version) VALUES ('20100823200602');

INSERT INTO schema_migrations (version) VALUES ('20100823202111');

INSERT INTO schema_migrations (version) VALUES ('20100825073929');

INSERT INTO schema_migrations (version) VALUES ('20100826154230');

INSERT INTO schema_migrations (version) VALUES ('20100826154431');

INSERT INTO schema_migrations (version) VALUES ('20100830184234');

INSERT INTO schema_migrations (version) VALUES ('20100830195510');

INSERT INTO schema_migrations (version) VALUES ('20100830195718');

INSERT INTO schema_migrations (version) VALUES ('20100831185904');

INSERT INTO schema_migrations (version) VALUES ('20100901233500');

INSERT INTO schema_migrations (version) VALUES ('20100909191616');

INSERT INTO schema_migrations (version) VALUES ('20100909191848');

INSERT INTO schema_migrations (version) VALUES ('20100914175614');

INSERT INTO schema_migrations (version) VALUES ('20100914201801');

INSERT INTO schema_migrations (version) VALUES ('20100914201933');

INSERT INTO schema_migrations (version) VALUES ('20100923050109');

INSERT INTO schema_migrations (version) VALUES ('20100923155830');

INSERT INTO schema_migrations (version) VALUES ('20100924151238');

INSERT INTO schema_migrations (version) VALUES ('20100929164102');

INSERT INTO schema_migrations (version) VALUES ('20101006140757');

INSERT INTO schema_migrations (version) VALUES ('20101103143026');

INSERT INTO schema_migrations (version) VALUES ('20101103175855');

INSERT INTO schema_migrations (version) VALUES ('20101103192208');

INSERT INTO schema_migrations (version) VALUES ('20101108025347');

INSERT INTO schema_migrations (version) VALUES ('20101108035650');

INSERT INTO schema_migrations (version) VALUES ('20101108173217');

INSERT INTO schema_migrations (version) VALUES ('20101108191504');

INSERT INTO schema_migrations (version) VALUES ('20101122190758');

INSERT INTO schema_migrations (version) VALUES ('20101122193317');

INSERT INTO schema_migrations (version) VALUES ('20101122201256');

INSERT INTO schema_migrations (version) VALUES ('20101126185106');

INSERT INTO schema_migrations (version) VALUES ('20101201153531');

INSERT INTO schema_migrations (version) VALUES ('20101202170027');

INSERT INTO schema_migrations (version) VALUES ('20101214173232');

INSERT INTO schema_migrations (version) VALUES ('20110106155626');

INSERT INTO schema_migrations (version) VALUES ('20110107155626');

INSERT INTO schema_migrations (version) VALUES ('20110111182832');

INSERT INTO schema_migrations (version) VALUES ('20110111183813');

INSERT INTO schema_migrations (version) VALUES ('20110112213956');

INSERT INTO schema_migrations (version) VALUES ('20110114102511');

INSERT INTO schema_migrations (version) VALUES ('20110118210525');

INSERT INTO schema_migrations (version) VALUES ('20110119215939');

INSERT INTO schema_migrations (version) VALUES ('20110128031602');

INSERT INTO schema_migrations (version) VALUES ('20110128160011');

INSERT INTO schema_migrations (version) VALUES ('20110128194000');

INSERT INTO schema_migrations (version) VALUES ('20110131213631');

INSERT INTO schema_migrations (version) VALUES ('20110208174632');

INSERT INTO schema_migrations (version) VALUES ('20110208193258');

INSERT INTO schema_migrations (version) VALUES ('20110211154810');

INSERT INTO schema_migrations (version) VALUES ('20110211220404');

INSERT INTO schema_migrations (version) VALUES ('20110215203523');

INSERT INTO schema_migrations (version) VALUES ('20110215205928');

INSERT INTO schema_migrations (version) VALUES ('20110222160242');

INSERT INTO schema_migrations (version) VALUES ('20110223184737');

INSERT INTO schema_migrations (version) VALUES ('20110223205049');

INSERT INTO schema_migrations (version) VALUES ('20110223205331');

INSERT INTO schema_migrations (version) VALUES ('20110224183744');

INSERT INTO schema_migrations (version) VALUES ('20110301154810');

INSERT INTO schema_migrations (version) VALUES ('20110301203231');

INSERT INTO schema_migrations (version) VALUES ('20110301222940');

INSERT INTO schema_migrations (version) VALUES ('20110304212106');

INSERT INTO schema_migrations (version) VALUES ('20110307201619');

INSERT INTO schema_migrations (version) VALUES ('20110307201620');

INSERT INTO schema_migrations (version) VALUES ('20110308195527');

INSERT INTO schema_migrations (version) VALUES ('20110308210209');

INSERT INTO schema_migrations (version) VALUES ('20110315171910');

INSERT INTO schema_migrations (version) VALUES ('20110316174918');

INSERT INTO schema_migrations (version) VALUES ('20110316175406');

INSERT INTO schema_migrations (version) VALUES ('20110316175449');

INSERT INTO schema_migrations (version) VALUES ('20110316175901');

INSERT INTO schema_migrations (version) VALUES ('20110316204341');

INSERT INTO schema_migrations (version) VALUES ('20110317151157');

INSERT INTO schema_migrations (version) VALUES ('20110321204932');

INSERT INTO schema_migrations (version) VALUES ('20110322200323');

INSERT INTO schema_migrations (version) VALUES ('20110323045225');

INSERT INTO schema_migrations (version) VALUES ('20110325195018');

INSERT INTO schema_migrations (version) VALUES ('20110401194148');

INSERT INTO schema_migrations (version) VALUES ('20110420151706');

INSERT INTO schema_migrations (version) VALUES ('20110421141855');

INSERT INTO schema_migrations (version) VALUES ('20110428200504');

INSERT INTO schema_migrations (version) VALUES ('20110429191416');

INSERT INTO schema_migrations (version) VALUES ('20110430171800');

INSERT INTO schema_migrations (version) VALUES ('20110430172354');

INSERT INTO schema_migrations (version) VALUES ('20110506202051');

INSERT INTO schema_migrations (version) VALUES ('20110512155352');

INSERT INTO schema_migrations (version) VALUES ('20110512184517');

INSERT INTO schema_migrations (version) VALUES ('20110512212548');

INSERT INTO schema_migrations (version) VALUES ('20110520215405');

INSERT INTO schema_migrations (version) VALUES ('20110602142800');

INSERT INTO schema_migrations (version) VALUES ('20110602175650');

INSERT INTO schema_migrations (version) VALUES ('20110610200458');

INSERT INTO schema_migrations (version) VALUES ('20110610222433');

INSERT INTO schema_migrations (version) VALUES ('20110617201034');

INSERT INTO schema_migrations (version) VALUES ('20110705155516');

INSERT INTO schema_migrations (version) VALUES ('20110719195436');

INSERT INTO schema_migrations (version) VALUES ('20110719200305');

INSERT INTO schema_migrations (version) VALUES ('20110719200503');

INSERT INTO schema_migrations (version) VALUES ('20110720155454');

INSERT INTO schema_migrations (version) VALUES ('20110808194357');

INSERT INTO schema_migrations (version) VALUES ('20110808200330');

INSERT INTO schema_migrations (version) VALUES ('20110808200700');

INSERT INTO schema_migrations (version) VALUES ('20110811182932');

INSERT INTO schema_migrations (version) VALUES ('20110816152322');

INSERT INTO schema_migrations (version) VALUES ('20110816152843');

INSERT INTO schema_migrations (version) VALUES ('20110816153613');

INSERT INTO schema_migrations (version) VALUES ('20110816163338');

INSERT INTO schema_migrations (version) VALUES ('20110822193729');

INSERT INTO schema_migrations (version) VALUES ('20110829182818');

INSERT INTO schema_migrations (version) VALUES ('20110829191742');

INSERT INTO schema_migrations (version) VALUES ('20111014200323');

INSERT INTO schema_migrations (version) VALUES ('20111020203807');

INSERT INTO schema_migrations (version) VALUES ('20111025133807');

INSERT INTO schema_migrations (version) VALUES ('20111028201951');

INSERT INTO schema_migrations (version) VALUES ('20111031134348');

INSERT INTO schema_migrations (version) VALUES ('20111226232135');

INSERT INTO schema_migrations (version) VALUES ('20120106144427');

INSERT INTO schema_migrations (version) VALUES ('20120110163038');

INSERT INTO schema_migrations (version) VALUES ('20120112044129');

INSERT INTO schema_migrations (version) VALUES ('20120216205433');

INSERT INTO schema_migrations (version) VALUES ('20120823153635');

INSERT INTO schema_migrations (version) VALUES ('20120827180923');

INSERT INTO schema_migrations (version) VALUES ('20120828160022');

INSERT INTO schema_migrations (version) VALUES ('20120830204312');

INSERT INTO schema_migrations (version) VALUES ('20120830204327');

INSERT INTO schema_migrations (version) VALUES ('20120830204328');

INSERT INTO schema_migrations (version) VALUES ('20120830204329');

INSERT INTO schema_migrations (version) VALUES ('20120830204330');

INSERT INTO schema_migrations (version) VALUES ('20120905151135');

INSERT INTO schema_migrations (version) VALUES ('20120905161442');

INSERT INTO schema_migrations (version) VALUES ('20120905161540');

INSERT INTO schema_migrations (version) VALUES ('20120905172445');

INSERT INTO schema_migrations (version) VALUES ('20120905172527');

INSERT INTO schema_migrations (version) VALUES ('20120905173308');

INSERT INTO schema_migrations (version) VALUES ('20120905173318');

INSERT INTO schema_migrations (version) VALUES ('20120905182321');

INSERT INTO schema_migrations (version) VALUES ('20120905184606');

INSERT INTO schema_migrations (version) VALUES ('20120905184615');

INSERT INTO schema_migrations (version) VALUES ('20120905193730');

INSERT INTO schema_migrations (version) VALUES ('20120905193740');

INSERT INTO schema_migrations (version) VALUES ('20120905223648');

INSERT INTO schema_migrations (version) VALUES ('20120907000422');

INSERT INTO schema_migrations (version) VALUES ('20120907002259');

INSERT INTO schema_migrations (version) VALUES ('20120907005909');

INSERT INTO schema_migrations (version) VALUES ('20120910132456');

INSERT INTO schema_migrations (version) VALUES ('20120910134254');

INSERT INTO schema_migrations (version) VALUES ('20120910134953');

INSERT INTO schema_migrations (version) VALUES ('20121016135537');

INSERT INTO schema_migrations (version) VALUES ('20121016141026');

INSERT INTO schema_migrations (version) VALUES ('20121017201423');

INSERT INTO schema_migrations (version) VALUES ('20121019021635');

INSERT INTO schema_migrations (version) VALUES ('20121019023646');

INSERT INTO schema_migrations (version) VALUES ('20121019150551');

INSERT INTO schema_migrations (version) VALUES ('20121019154738');

INSERT INTO schema_migrations (version) VALUES ('20121022155249');

INSERT INTO schema_migrations (version) VALUES ('20121023153757');

INSERT INTO schema_migrations (version) VALUES ('20121023200723');

INSERT INTO schema_migrations (version) VALUES ('20121025173248');

INSERT INTO schema_migrations (version) VALUES ('20121107153348');

INSERT INTO schema_migrations (version) VALUES ('20121126210802');

INSERT INTO schema_migrations (version) VALUES ('20121127232337');

INSERT INTO schema_migrations (version) VALUES ('20121130205225');

INSERT INTO schema_migrations (version) VALUES ('20121220165950');

INSERT INTO schema_migrations (version) VALUES ('20130115190751');

INSERT INTO schema_migrations (version) VALUES ('20130115211726');

INSERT INTO schema_migrations (version) VALUES ('20130117165614');

INSERT INTO schema_migrations (version) VALUES ('20130121152625');

INSERT INTO schema_migrations (version) VALUES ('20130123202332');

INSERT INTO schema_migrations (version) VALUES ('20130129212854');

INSERT INTO schema_migrations (version) VALUES ('20130130233833');

INSERT INTO schema_migrations (version) VALUES ('20130201000147');

INSERT INTO schema_migrations (version) VALUES ('20130213194724');

INSERT INTO schema_migrations (version) VALUES ('20130214230240');

INSERT INTO schema_migrations (version) VALUES ('20130327192956');

INSERT INTO schema_migrations (version) VALUES ('20130403183206');

INSERT INTO schema_migrations (version) VALUES ('21');

INSERT INTO schema_migrations (version) VALUES ('22');

INSERT INTO schema_migrations (version) VALUES ('23');

INSERT INTO schema_migrations (version) VALUES ('25');

INSERT INTO schema_migrations (version) VALUES ('26');

INSERT INTO schema_migrations (version) VALUES ('27');

INSERT INTO schema_migrations (version) VALUES ('28');

INSERT INTO schema_migrations (version) VALUES ('29');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('30');

INSERT INTO schema_migrations (version) VALUES ('31');

INSERT INTO schema_migrations (version) VALUES ('32');

INSERT INTO schema_migrations (version) VALUES ('33');

INSERT INTO schema_migrations (version) VALUES ('34');

INSERT INTO schema_migrations (version) VALUES ('35');

INSERT INTO schema_migrations (version) VALUES ('36');

INSERT INTO schema_migrations (version) VALUES ('37');

INSERT INTO schema_migrations (version) VALUES ('38');

INSERT INTO schema_migrations (version) VALUES ('39');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('40');

INSERT INTO schema_migrations (version) VALUES ('41');

INSERT INTO schema_migrations (version) VALUES ('42');

INSERT INTO schema_migrations (version) VALUES ('43');

INSERT INTO schema_migrations (version) VALUES ('44');

INSERT INTO schema_migrations (version) VALUES ('45');

INSERT INTO schema_migrations (version) VALUES ('46');

INSERT INTO schema_migrations (version) VALUES ('47');

INSERT INTO schema_migrations (version) VALUES ('48');

INSERT INTO schema_migrations (version) VALUES ('49');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('50');

INSERT INTO schema_migrations (version) VALUES ('51');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');