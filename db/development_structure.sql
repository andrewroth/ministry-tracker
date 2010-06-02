<<<<<<< HEAD:db/development_structure.sql
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
) ENGINE=InnoDB AUTO_INCREMENT=3621 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
=======
CREATE TABLE `columns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `update_clause` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `from_clause` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `select_clause` text COLLATE utf8_unicode_ci,
  `column_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `writeable` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `join_clause` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_model` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_column` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `foreign_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `conference_registrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conference_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
<<<<<<< HEAD:db/development_structure.sql
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
=======
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `conferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `custom_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
<<<<<<< HEAD:db/development_structure.sql
  `name` varchar(255) DEFAULT NULL,
  `value_type` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_custom_attributes_on_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
=======
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_custom_attributes_on_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `custom_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `custom_attribute_id` int(11) DEFAULT NULL,
<<<<<<< HEAD:db/development_structure.sql
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
=======
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
<<<<<<< HEAD:db/development_structure.sql
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

CREATE TABLE `dorms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campus_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_dorms_on_campus_id` (`campus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

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
=======
  `handler` text COLLATE utf8_unicode_ci,
  `last_error` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `people_ids` text COLLATE utf8_unicode_ci,
  `missing_address_ids` text COLLATE utf8_unicode_ci,
>>>>>>> dev:db/development_structure.sql
  `search_id` int(11) DEFAULT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
<<<<<<< HEAD:db/development_structure.sql
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
=======
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `free_times` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` int(11) DEFAULT NULL,
  `end_time` int(11) DEFAULT NULL,
  `day_of_week` int(11) DEFAULT NULL,
  `timetable_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
<<<<<<< HEAD:db/development_structure.sql
  `css_class` varchar(255) DEFAULT NULL,
  `weight` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44900 DEFAULT CHARSET=utf8;
=======
  `css_class` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `weight` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `group_involvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
<<<<<<< HEAD:db/development_structure.sql
  `level` varchar(255) DEFAULT NULL,
  `requested` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `person_id_group_id` (`person_id`,`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2817 DEFAULT CHARSET=utf8;
=======
  `level` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `requested` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `person_id_group_id` (`person_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `group_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
<<<<<<< HEAD:db/development_structure.sql
  `group_type` varchar(255) DEFAULT NULL,
=======
  `group_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
>>>>>>> dev:db/development_structure.sql
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `mentor_priority` tinyint(1) DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL,
  `unsuitability_leader` int(11) DEFAULT NULL,
  `unsuitability_coleader` int(11) DEFAULT NULL,
  `unsuitability_participant` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
<<<<<<< HEAD:db/development_structure.sql
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
=======
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address_2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
>>>>>>> dev:db/development_structure.sql
  `dorm_id` int(11) DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  `start_time` int(11) DEFAULT NULL,
  `end_time` int(11) DEFAULT NULL,
  `day` int(11) DEFAULT NULL,
  `group_type_id` int(11) DEFAULT NULL,
  `needs_approval` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_groups_on_campus_id` (`campus_id`),
  KEY `index_groups_on_dorm_id` (`dorm_id`),
  KEY `index_groups_on_ministry_id` (`ministry_id`)
<<<<<<< HEAD:db/development_structure.sql
) ENGINE=InnoDB AUTO_INCREMENT=371 DEFAULT CHARSET=utf8;
=======
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `imports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
<<<<<<< HEAD:db/development_structure.sql
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  PRIMARY KEY (`id`),
  KEY `index_ministries_on_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

CREATE TABLE `ministry_campuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `campus_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ministry_campuses_on_ministry_id_and_campus_id` (`ministry_id`,`campus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=4100 DEFAULT CHARSET=utf8;
=======
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `ministry_role_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_id` int(11) DEFAULT NULL,
  `ministry_role_id` int(11) DEFAULT NULL,
<<<<<<< HEAD:db/development_structure.sql
  `created_at` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=1316 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
=======
  `created_at` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `controller` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `searches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
<<<<<<< HEAD:db/development_structure.sql
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
) ENGINE=InnoDB AUTO_INCREMENT=2596 DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
=======
  `options` text COLLATE utf8_unicode_ci,
  `query` text COLLATE utf8_unicode_ci,
  `tables` text COLLATE utf8_unicode_ci,
  `saved` tinyint(1) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `order` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `data` text COLLATE utf8_unicode_ci,
>>>>>>> dev:db/development_structure.sql
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
<<<<<<< HEAD:db/development_structure.sql
) ENGINE=InnoDB AUTO_INCREMENT=26561 DEFAULT CHARSET=utf8;
=======
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_staff_on_ministry_id` (`ministry_id`)
<<<<<<< HEAD:db/development_structure.sql
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `abbreviation` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
=======
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `stint_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stint_location_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
<<<<<<< HEAD:db/development_structure.sql
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `stint_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
=======
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stint_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `summer_project_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `summer_project_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
<<<<<<< HEAD:db/development_structure.sql
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
=======
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `summer_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `timetables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
<<<<<<< HEAD:db/development_structure.sql
) ENGINE=InnoDB AUTO_INCREMENT=2930 DEFAULT CHARSET=utf8;
=======
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `training_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `training_question_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `completed_at` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
<<<<<<< HEAD:db/development_structure.sql
  `approved_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `training_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
=======
  `approved_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `training_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
>>>>>>> dev:db/development_structure.sql
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
<<<<<<< HEAD:db/development_structure.sql
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
=======
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
>>>>>>> dev:db/development_structure.sql

CREATE TABLE `training_question_activations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `training_question_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `mandate` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
<<<<<<< HEAD:db/development_structure.sql
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `training_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity` varchar(255) DEFAULT NULL,
=======
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `training_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
>>>>>>> dev:db/development_structure.sql
  `ministry_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `training_category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
<<<<<<< HEAD:db/development_structure.sql
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
=======
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `view_columns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `view_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `column_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
>>>>>>> dev:db/development_structure.sql
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `view_columns_column_id` (`column_id`,`view_id`),
  KEY `index_view_columns_on_view_id` (`view_id`)
<<<<<<< HEAD:db/development_structure.sql
) ENGINE=InnoDB AUTO_INCREMENT=226 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

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

INSERT INTO schema_migrations (version) VALUES ('20091008020514');

INSERT INTO schema_migrations (version) VALUES ('20091012000730');

INSERT INTO schema_migrations (version) VALUES ('20091103202343');

INSERT INTO schema_migrations (version) VALUES ('20091104204904');

INSERT INTO schema_migrations (version) VALUES ('20100109055730');

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
=======
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ministry_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `default_view` tinyint(1) DEFAULT NULL,
  `select_clause` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tables_clause` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20100525190119');
>>>>>>> dev:db/development_structure.sql
