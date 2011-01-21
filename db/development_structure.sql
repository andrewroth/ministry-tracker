CREATE TABLE `addresses` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `address_type` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `address1` varchar(255) default NULL,
  `address2` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `zip` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `phone` varchar(255) default NULL,
  `alternate_phone` varchar(255) default NULL,
  `dorm` varchar(255) default NULL,
  `room` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `created_at` date default NULL,
  `updated_at` date default NULL,
  `email_validated` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_addresses_on_email` (`email`),
  KEY `index_addresses_on_person_id` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `campus_involvements` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `campus_id` int(11) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `ministry_id` int(11) default NULL,
  `added_by_id` int(11) default NULL,
  `graduation_date` date default NULL,
  `school_year_id` int(11) default NULL,
  `major` varchar(255) default NULL,
  `minor` varchar(255) default NULL,
  `last_history_update_date` date default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_campus_involvements_on_p_id_and_c_id_and_end_date` (`person_id`,`campus_id`,`end_date`),
  KEY `index_campus_involvements_on_campus_id` (`campus_id`),
  KEY `index_campus_involvements_on_ministry_id` (`ministry_id`),
  KEY `index_campus_involvements_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5316 DEFAULT CHARSET=utf8;

CREATE TABLE `campus_ministry_groups` (
  `id` int(11) NOT NULL auto_increment,
  `group_id` int(11) default NULL,
  `campus_id` int(11) default NULL,
  `ministry_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

CREATE TABLE `campuses` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `address` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `zip` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `phone` varchar(255) default NULL,
  `fax` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `abbrv` varchar(255) default NULL,
  `is_secure` tinyint(1) default NULL,
  `enrollment` int(11) default NULL,
  `created_at` date default NULL,
  `updated_at` date default NULL,
  `type` varchar(255) default NULL,
  `address2` varchar(255) default NULL,
  `county` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_campuses_on_county` (`county`),
  KEY `index_campuses_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `columns` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `update_clause` varchar(255) default NULL,
  `from_clause` varchar(255) default NULL,
  `select_clause` text,
  `column_type` varchar(255) default NULL,
  `writeable` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `join_clause` varchar(255) default NULL,
  `source_model` varchar(255) default NULL,
  `source_column` varchar(255) default NULL,
  `foreign_key` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

CREATE TABLE `conference_registrations` (
  `id` int(11) NOT NULL auto_increment,
  `conference_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `conferences` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `correspondence_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `overdue_lifespan` int(11) default NULL,
  `expiry_lifespan` int(11) default NULL,
  `actions_now_task` varchar(255) default NULL,
  `actions_overdue_task` varchar(255) default NULL,
  `actions_followup_task` varchar(255) default NULL,
  `redirect_params` text,
  `redirect_target_id_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `correspondences` (
  `id` int(11) NOT NULL auto_increment,
  `correspondence_type_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `receipt` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `visited` date default NULL,
  `completed` date default NULL,
  `overdue_at` date default NULL,
  `expire_at` date default NULL,
  `token_params` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_correspondences_on_receipt` (`receipt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `counties` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_counties_on_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL auto_increment,
  `country` varchar(255) default NULL,
  `code` varchar(255) default NULL,
  `is_closed` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `custom_attributes` (
  `id` int(11) NOT NULL auto_increment,
  `ministry_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `value_type` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_custom_attributes_on_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `custom_values` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `custom_attribute_id` int(11) default NULL,
  `value` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL auto_increment,
  `priority` int(11) default '0',
  `attempts` int(11) default '0',
  `handler` text,
  `last_error` varchar(255) default NULL,
  `run_at` datetime default NULL,
  `locked_at` datetime default NULL,
  `failed_at` datetime default NULL,
  `locked_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1186 DEFAULT CHARSET=utf8;

CREATE TABLE `dismissed_notices` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `notice_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dorms` (
  `id` int(11) NOT NULL auto_increment,
  `campus_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `created_at` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_dorms_on_campus_id` (`campus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

CREATE TABLE `email_templates` (
  `id` int(11) NOT NULL auto_increment,
  `correspondence_type_id` int(11) default NULL,
  `outcome_type` varchar(255) default NULL,
  `subject` varchar(255) NOT NULL,
  `from` varchar(255) NOT NULL,
  `bcc` varchar(255) default NULL,
  `cc` varchar(255) default NULL,
  `body` text NOT NULL,
  `template` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `emails` (
  `id` int(11) NOT NULL auto_increment,
  `subject` varchar(255) default NULL,
  `body` text,
  `people_ids` text,
  `missing_address_ids` text,
  `search_id` int(11) default NULL,
  `sender_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET=utf8;

CREATE TABLE `event_campuses` (
  `id` int(11) NOT NULL auto_increment,
  `event_id` int(11) default NULL,
  `campus_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

CREATE TABLE `event_groups` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `events` (
  `id` int(11) NOT NULL auto_increment,
  `registrar_event_id` int(11) default NULL,
  `event_group_id` int(11) default NULL,
  `register_url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

CREATE TABLE `free_times` (
  `id` int(11) NOT NULL auto_increment,
  `start_time` int(11) default NULL,
  `end_time` int(11) default NULL,
  `day_of_week` int(11) default NULL,
  `timetable_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `css_class` varchar(255) default NULL,
  `weight` decimal(4,2) default NULL,
  PRIMARY KEY  (`id`),
  KEY `free_times_timetable_id` (`timetable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=143814 DEFAULT CHARSET=utf8;

CREATE TABLE `group_involvements` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `level` varchar(255) default NULL,
  `requested` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `person_id_group_id` (`person_id`,`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7257 DEFAULT CHARSET=utf8;

CREATE TABLE `group_types` (
  `id` int(11) NOT NULL auto_increment,
  `ministry_id` int(11) default NULL,
  `group_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `mentor_priority` tinyint(1) default NULL,
  `public` tinyint(1) default NULL,
  `unsuitability_leader` int(11) default NULL,
  `unsuitability_coleader` int(11) default NULL,
  `unsuitability_participant` int(11) default NULL,
  `collection_group_name` varchar(255) default '{{campus}} interested in a {{group_type}}',
  `has_collection_groups` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `address` varchar(255) default NULL,
  `address_2` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `zip` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `dorm_id` int(11) default NULL,
  `ministry_id` int(11) default NULL,
  `campus_id` int(11) default NULL,
  `start_time` int(11) default NULL,
  `end_time` int(11) default NULL,
  `day` int(11) default NULL,
  `group_type_id` int(11) default NULL,
  `needs_approval` tinyint(1) default NULL,
  `semester_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_groups_on_campus_id` (`campus_id`),
  KEY `index_groups_on_dorm_id` (`dorm_id`),
  KEY `index_groups_on_ministry_id` (`ministry_id`),
  KEY `index_emu.groups_on_semester_id` (`semester_id`)
) ENGINE=InnoDB AUTO_INCREMENT=843 DEFAULT CHARSET=utf8;

CREATE TABLE `imports` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `size` int(11) default NULL,
  `height` int(11) default NULL,
  `width` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `filename` varchar(255) default NULL,
  `thumbnail` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `involvement_histories` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `person_id` int(11) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `campus_id` int(11) default NULL,
  `school_year_id` int(11) default NULL,
  `ministry_id` int(11) default NULL,
  `ministry_role_id` int(11) default NULL,
  `campus_involvement_id` int(11) default NULL,
  `ministry_involvement_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1013 DEFAULT CHARSET=utf8;

CREATE TABLE `ministries` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `address` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `zip` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `phone` varchar(255) default NULL,
  `fax` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `created_at` date default NULL,
  `updated_at` date default NULL,
  `ministries_count` int(11) default NULL,
  `type` varchar(255) default NULL,
  `lft` int(11) default NULL,
  `rgt` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_ministries_on_parent_id` (`parent_id`),
  KEY `index_emu.ministries_on_lft` (`lft`),
  KEY `index_emu.ministries_on_rgt` (`rgt`),
  KEY `index_emu.ministries_on_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_campuses` (
  `id` int(11) NOT NULL auto_increment,
  `ministry_id` int(11) default NULL,
  `campus_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_ministry_campuses_on_ministry_id_and_campus_id` (`ministry_id`,`campus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_involvements` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `ministry_id` int(11) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `admin` tinyint(1) default NULL,
  `ministry_role_id` int(11) default NULL,
  `responsible_person_id` int(11) default NULL,
  `last_history_update_date` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_ministry_involvements_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9577 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_role_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `permission_id` int(11) default NULL,
  `ministry_role_id` int(11) default NULL,
  `created_at` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=508 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_roles` (
  `id` int(11) NOT NULL auto_increment,
  `ministry_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `created_at` date default NULL,
  `position` int(11) default NULL,
  `description` varchar(255) default NULL,
  `type` varchar(255) default NULL,
  `involved` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_ministry_roles_on_ministry_id` (`ministry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

CREATE TABLE `notices` (
  `id` int(11) NOT NULL auto_increment,
  `message` text,
  `live` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `preferred_name` varchar(255) default NULL,
  `gender` varchar(255) default NULL,
  `year_in_school` varchar(255) default NULL,
  `level_of_school` varchar(255) default NULL,
  `graduation_date` date default NULL,
  `major` varchar(255) default NULL,
  `minor` varchar(255) default NULL,
  `birth_date` date default NULL,
  `bio` text,
  `image` varchar(255) default NULL,
  `created_at` date default NULL,
  `updated_at` date default NULL,
  `staff_notes` varchar(255) default NULL,
  `updated_by` int(11) default NULL,
  `created_by` int(11) default NULL,
  `url` varchar(2000) default NULL,
  `primary_campus_involvement_id` int(11) default NULL,
  `mentor_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_people_on_user_id` (`user_id`),
  KEY `index_people_on_first_name` (`first_name`),
  KEY `index_people_on_last_name_and_first_name` (`last_name`,`first_name`),
  KEY `index_people_on_major_and_minor` (`major`,`minor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `description` varchar(1000) default NULL,
  `controller` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8;

CREATE TABLE `person_extras` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `major` varchar(255) default NULL,
  `minor` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `staff_notes` varchar(255) default NULL,
  `updated_at` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `perm_start_date` date default NULL,
  `perm_end_date` date default NULL,
  `perm_dorm` varchar(255) default NULL,
  `perm_room` varchar(255) default NULL,
  `perm_alternate_phone` varchar(255) default NULL,
  `curr_start_date` date default NULL,
  `curr_end_date` date default NULL,
  `curr_dorm` varchar(255) default NULL,
  `curr_room` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_person_extras_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3602 DEFAULT CHARSET=utf8;

CREATE TABLE `profile_pictures` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `size` int(11) default NULL,
  `height` int(11) default NULL,
  `width` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `filename` varchar(255) default NULL,
  `thumbnail` varchar(255) default NULL,
  `uploaded_date` date default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=693 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `school_years` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `level` varchar(255) default NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `searches` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `options` text,
  `query` text,
  `tables` text,
  `saved` tinyint(1) default NULL,
  `name` varchar(255) default NULL,
  `order` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8309 DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=139901 DEFAULT CHARSET=utf8;

CREATE TABLE `staff` (
  `id` int(11) NOT NULL auto_increment,
  `ministry_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `created_at` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_staff_on_ministry_id` (`ministry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `states` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `abbreviation` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `stint_applications` (
  `id` int(11) NOT NULL auto_increment,
  `stint_location_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `stint_locations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `strategies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `abbrv` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `summer_project_applications` (
  `id` int(11) NOT NULL auto_increment,
  `summer_project_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `status` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `summer_projects` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `timetables` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `updated_by_person_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_c4c_pulse_staging.timetables_on_person_id` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5185 DEFAULT CHARSET=utf8;

CREATE TABLE `training_answers` (
  `id` int(11) NOT NULL auto_increment,
  `training_question_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `completed_at` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `approved_by` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `training_categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `ministry_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `training_question_activations` (
  `id` int(11) NOT NULL auto_increment,
  `ministry_id` int(11) default NULL,
  `training_question_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `mandate` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `training_questions` (
  `id` int(11) NOT NULL auto_increment,
  `activity` varchar(255) default NULL,
  `ministry_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `training_category_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_codes` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `code` varchar(255) default NULL,
  `pass` text,
  PRIMARY KEY  (`id`),
  KEY `index_user_codes_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1028 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(255) default NULL,
  `password` varchar(255) default NULL,
  `last_login` datetime default NULL,
  `system_admin` tinyint(1) default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `guid` varchar(255) default NULL,
  `email_validated` tinyint(1) default NULL,
  `developer` tinyint(1) default NULL,
  `facebook_hash` varchar(255) default NULL,
  `facebook_username` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `view_columns` (
  `id` int(11) NOT NULL auto_increment,
  `view_id` varchar(255) default NULL,
  `column_id` varchar(255) default NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `view_columns_column_id` (`column_id`,`view_id`),
  KEY `index_view_columns_on_view_id` (`view_id`)
) ENGINE=InnoDB AUTO_INCREMENT=530 DEFAULT CHARSET=utf8;

CREATE TABLE `views` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `ministry_id` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `default_view` tinyint(1) default NULL,
  `select_clause` varchar(2000) default NULL,
  `tables_clause` varchar(2000) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;

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

INSERT INTO schema_migrations (version) VALUES ('20101122193317');

INSERT INTO schema_migrations (version) VALUES ('20101126185106');

INSERT INTO schema_migrations (version) VALUES ('201101141025111');

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