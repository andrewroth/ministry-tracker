CREATE TABLE `campus_ministry_groups` (
  `id` int(11) NOT NULL auto_increment,
  `group_id` int(11) default NULL,
  `campus_id` int(11) default NULL,
  `ministry_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `columns` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) collate utf8_unicode_ci default NULL,
  `update_clause` varchar(255) collate utf8_unicode_ci default NULL,
  `from_clause` varchar(255) collate utf8_unicode_ci default NULL,
  `select_clause` text collate utf8_unicode_ci,
  `column_type` varchar(255) collate utf8_unicode_ci default NULL,
  `writeable` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `join_clause` varchar(255) collate utf8_unicode_ci default NULL,
  `source_model` varchar(255) collate utf8_unicode_ci default NULL,
  `source_column` varchar(255) collate utf8_unicode_ci default NULL,
  `foreign_key` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `conference_registrations` (
  `id` int(11) NOT NULL auto_increment,
  `conference_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `conferences` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `custom_attributes` (
  `id` int(11) NOT NULL auto_increment,
  `ministry_id` int(11) default NULL,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `value_type` varchar(255) collate utf8_unicode_ci default NULL,
  `description` varchar(255) collate utf8_unicode_ci default NULL,
  `type` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_custom_attributes_on_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `custom_values` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `custom_attribute_id` int(11) default NULL,
  `value` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL auto_increment,
  `priority` int(11) default '0',
  `attempts` int(11) default '0',
  `handler` text collate utf8_unicode_ci,
  `last_error` varchar(255) collate utf8_unicode_ci default NULL,
  `run_at` datetime default NULL,
  `locked_at` datetime default NULL,
  `failed_at` datetime default NULL,
  `locked_by` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `dismissed_notices` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `notice_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `emails` (
  `id` int(11) NOT NULL auto_increment,
  `subject` varchar(255) collate utf8_unicode_ci default NULL,
  `body` text collate utf8_unicode_ci,
  `people_ids` text collate utf8_unicode_ci,
  `missing_address_ids` text collate utf8_unicode_ci,
  `search_id` int(11) default NULL,
  `sender_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `event_campuses` (
  `id` int(11) NOT NULL auto_increment,
  `event_id` int(11) default NULL,
  `campus_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `event_groups` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) collate utf8_unicode_ci default NULL,
  `description` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `events` (
  `id` int(11) NOT NULL auto_increment,
  `registrar_event_id` int(11) default NULL,
  `event_group_id` int(11) default NULL,
  `register_url` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `free_times` (
  `id` int(11) NOT NULL auto_increment,
  `start_time` int(11) default NULL,
  `end_time` int(11) default NULL,
  `day_of_week` int(11) default NULL,
  `timetable_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `css_class` varchar(255) collate utf8_unicode_ci default NULL,
  `weight` decimal(4,2) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `group_involvements` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `level` varchar(255) collate utf8_unicode_ci default NULL,
  `requested` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `person_id_group_id` (`person_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `group_types` (
  `id` int(11) NOT NULL auto_increment,
  `ministry_id` int(11) default NULL,
  `group_type` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `mentor_priority` tinyint(1) default NULL,
  `public` tinyint(1) default NULL,
  `unsuitability_leader` int(11) default NULL,
  `unsuitability_coleader` int(11) default NULL,
  `unsuitability_participant` int(11) default NULL,
  `collection_group_name` varchar(255) collate utf8_unicode_ci default '{{campus}} interested in a {{group_type}}',
  `has_collection_groups` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `address` varchar(255) collate utf8_unicode_ci default NULL,
  `address_2` varchar(255) collate utf8_unicode_ci default NULL,
  `city` varchar(255) collate utf8_unicode_ci default NULL,
  `state` varchar(255) collate utf8_unicode_ci default NULL,
  `zip` varchar(255) collate utf8_unicode_ci default NULL,
  `country` varchar(255) collate utf8_unicode_ci default NULL,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `url` varchar(255) collate utf8_unicode_ci default NULL,
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
  KEY `index_groups_on_semester_id` (`semester_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `imports` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `size` int(11) default NULL,
  `height` int(11) default NULL,
  `width` int(11) default NULL,
  `content_type` varchar(255) collate utf8_unicode_ci default NULL,
  `filename` varchar(255) collate utf8_unicode_ci default NULL,
  `thumbnail` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ministry_role_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `permission_id` int(11) default NULL,
  `ministry_role_id` int(11) default NULL,
  `created_at` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `news` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) collate utf8_unicode_ci default NULL,
  `message` text collate utf8_unicode_ci,
  `group_id` int(11) default NULL,
  `ministry_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `sticky` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `staff` tinyint(1) default NULL,
  `students` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `news_comments` (
  `id` int(11) NOT NULL auto_increment,
  `news_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `comment` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `notices` (
  `id` int(11) NOT NULL auto_increment,
  `message` text collate utf8_unicode_ci,
  `live` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `description` varchar(1000) collate utf8_unicode_ci default NULL,
  `controller` varchar(255) collate utf8_unicode_ci default NULL,
  `action` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `person_news` (
  `id` int(11) NOT NULL auto_increment,
  `news_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `hidden` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_person_news_on_news_id` (`news_id`),
  KEY `index_person_news_on_person_id` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) collate utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `searches` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `options` text collate utf8_unicode_ci,
  `query` text collate utf8_unicode_ci,
  `tables` text collate utf8_unicode_ci,
  `saved` tinyint(1) default NULL,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `order` varchar(255) collate utf8_unicode_ci default NULL,
  `description` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `semesters` (
  `id` int(11) NOT NULL auto_increment,
  `year_id` int(11) default NULL,
  `start_date` date default NULL,
  `desc` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) collate utf8_unicode_ci NOT NULL,
  `data` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `staff` (
  `id` int(11) NOT NULL auto_increment,
  `ministry_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `created_at` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_staff_on_ministry_id` (`ministry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stint_applications` (
  `id` int(11) NOT NULL auto_increment,
  `stint_location_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stint_locations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `strategies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `abbrv` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `summer_project_applications` (
  `id` int(11) NOT NULL auto_increment,
  `summer_project_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `status` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `summer_projects` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `timetables` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `training_answers` (
  `id` int(11) NOT NULL auto_increment,
  `training_question_id` int(11) default NULL,
  `person_id` int(11) default NULL,
  `completed_at` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `approved_by` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `training_categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `ministry_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `training_question_activations` (
  `id` int(11) NOT NULL auto_increment,
  `ministry_id` int(11) default NULL,
  `training_question_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `mandate` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `training_questions` (
  `id` int(11) NOT NULL auto_increment,
  `activity` varchar(255) collate utf8_unicode_ci default NULL,
  `ministry_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `training_category_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_codes` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `code` varchar(255) collate utf8_unicode_ci default NULL,
  `pass` text collate utf8_unicode_ci,
  PRIMARY KEY  (`id`),
  KEY `index_user_codes_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `view_columns` (
  `id` int(11) NOT NULL auto_increment,
  `view_id` varchar(255) collate utf8_unicode_ci default NULL,
  `column_id` varchar(255) collate utf8_unicode_ci default NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `view_columns_column_id` (`column_id`,`view_id`),
  KEY `index_view_columns_on_view_id` (`view_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `views` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) collate utf8_unicode_ci default NULL,
  `ministry_id` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `default_view` tinyint(1) default NULL,
  `select_clause` varchar(2000) collate utf8_unicode_ci default NULL,
  `tables_clause` varchar(2000) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `years` (
  `id` int(11) NOT NULL auto_increment,
  `desc` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20100624184736');

INSERT INTO schema_migrations (version) VALUES ('20100628192154');

INSERT INTO schema_migrations (version) VALUES ('20100630042925');

INSERT INTO schema_migrations (version) VALUES ('20100708013548');

INSERT INTO schema_migrations (version) VALUES ('20100708013617');

INSERT INTO schema_migrations (version) VALUES ('20100708032653');

INSERT INTO schema_migrations (version) VALUES ('20100816023643');

INSERT INTO schema_migrations (version) VALUES ('20100818015210');

INSERT INTO schema_migrations (version) VALUES ('20100818015834');

INSERT INTO schema_migrations (version) VALUES ('20100830184234');

INSERT INTO schema_migrations (version) VALUES ('20100830195510');

INSERT INTO schema_migrations (version) VALUES ('20100830195718');

INSERT INTO schema_migrations (version) VALUES ('20100923050109');

INSERT INTO schema_migrations (version) VALUES ('20101108025347');

INSERT INTO schema_migrations (version) VALUES ('20101108035650');