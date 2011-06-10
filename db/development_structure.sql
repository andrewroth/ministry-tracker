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
) ENGINE=InnoDB AUTO_INCREMENT=6013 DEFAULT CHARSET=utf8;

CREATE TABLE `campus_ministry_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=641 DEFAULT CHARSET=utf8;

CREATE TABLE `event_campuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

CREATE TABLE `event_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registrar_event_id` int(11) DEFAULT NULL,
  `event_group_id` int(11) DEFAULT NULL,
  `register_url` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=191318 DEFAULT CHARSET=utf8;

CREATE TABLE `global_areas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `area` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=latin1;

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
  `pop_2010` int(11) DEFAULT NULL,
  `pop_2015` int(11) DEFAULT NULL,
  `pop_2020` int(11) DEFAULT NULL,
  `pop_wfb_gdppp` int(11) DEFAULT NULL,
  `perc_christian` float DEFAULT NULL,
  `perc_evangelical` float DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=2744 DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB AUTO_INCREMENT=36338 DEFAULT CHARSET=latin1;

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
  KEY `index_c4c_pulse_dev.group_invitations_on_group_id` (`group_id`),
  KEY `index_c4c_pulse_dev.group_invitations_on_login_code_id` (`login_code_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `group_involvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `level` varchar(255) DEFAULT NULL,
  `requested` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `person_id_group_id` (`person_id`,`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10838 DEFAULT CHARSET=utf8;

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
  KEY `index_emu.groups_on_semester_id` (`semester_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1261 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=1391 DEFAULT CHARSET=utf8;

CREATE TABLE `label_people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

CREATE TABLE `labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) DEFAULT NULL,
  `priority` int(11) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `locks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `locked` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `login_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acceptable` tinyint(1) DEFAULT '1',
  `times_used` int(11) DEFAULT '0',
  `code` varchar(255) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_c4c_pulse_dev.login_codes_on_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=1006 DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_campuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ministry_campuses_on_ministry_id_and_campus_id` (`ministry_id`,`campus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=10321 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_role_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_id` int(11) DEFAULT NULL,
  `ministry_role_id` int(11) DEFAULT NULL,
  `created_at` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=654 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `involved` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ministry_roles_on_ministry_id` (`ministry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

CREATE TABLE `notices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text,
  `live` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8;

CREATE TABLE `person_extras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `major` varchar(255) DEFAULT NULL,
  `minor` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `staff_notes` varchar(255) DEFAULT NULL,
  `updated_at` varchar(255) DEFAULT NULL,
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
  PRIMARY KEY (`id`),
  KEY `index_person_extras_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12350 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=853 DEFAULT CHARSET=utf8;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9715 DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=305150 DEFAULT CHARSET=utf8;

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

CREATE TABLE `temp_group_involvements` (
  `person_id` int(11) DEFAULT NULL,
  `group_involvements` varchar(255) DEFAULT NULL,
  KEY `index_temp_group_involvements_on_person_id` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `timetables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by_person_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emu.timetables_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5819 DEFAULT CHARSET=utf8;

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
  KEY `index_c4c_pulse_dev.user_codes_on_login_code_id` (`login_code_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1006 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=779 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8;

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