CREATE TABLE `twitter_follwer_status_histories` (
  `status_id` int(11) DEFAULT NULL,
  `follower` int(11) DEFAULT NULL,
  `get_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `favourites_count` int(11) DEFAULT NULL,
  `friends_count` int(11) DEFAULT NULL,
  `listed_count` int(11) DEFAULT NULL,
  `screen_name` varchar(255) DEFAULT NULL,
  `profile_image_url` varchar(255) DEFAULT NULL,
  `statuses_count` int(11) DEFAULT NULL,
  KEY `twitter_follwer_status_histories_key1` (`status_id`,`get_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;