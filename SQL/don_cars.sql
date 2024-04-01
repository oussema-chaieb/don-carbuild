CREATE TABLE `don_cars` (
  `plate` varchar(64) NOT NULL DEFAULT '',
  `identifier` varchar(64) NOT NULL DEFAULT '',
  `paint` varchar(128) DEFAULT NULL,
  `coord` varchar(255) DEFAULT NULL,
  `model` varchar(64) DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `props` text NOT NULL,
  `state` int(2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `don_cars`
  ADD PRIMARY KEY (`plate`);
COMMIT;