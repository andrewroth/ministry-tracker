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

CREATE TABLE `conference_registrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conference_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `conferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `custom_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_custom_attributes_on_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `custom_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `custom_attribute_id` int(11) DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
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
  `search_id` int(11) DEFAULT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `free_times` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` int(11) DEFAULT NULL,
  `end_time` int(11) DEFAULT NULL,
  `day_of_week` int(11) DEFAULT NULL,
  `timetable_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `css_class` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `weight` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `group_involvements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `level` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `requested` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `person_id_group_id` (`person_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `group_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `group_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `mentor_priority` tinyint(1) DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL,
  `unsuitability_leader` int(11) DEFAULT NULL,
  `unsuitability_coleader` int(11) DEFAULT NULL,
  `unsuitability_participant` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `imports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ministry_role_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_id` int(11) DEFAULT NULL,
  `ministry_role_id` int(11) DEFAULT NULL,
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

CREATE TABLE `searches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
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
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_staff_on_ministry_id` (`ministry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stint_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stint_location_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stint_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `summer_project_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `summer_project_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
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

CREATE TABLE `timetables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `training_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `training_question_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `completed_at` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `approved_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `training_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `training_question_activations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ministry_id` int(11) DEFAULT NULL,
  `training_question_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `mandate` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `training_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ministry_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `training_category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `view_columns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `view_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `column_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `view_columns_column_id` (`column_id`,`view_id`),
  KEY `index_view_columns_on_view_id` (`view_id`)
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