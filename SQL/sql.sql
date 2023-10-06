CREATE TABLE `don_cars` (
  `plate` varchar(64) NOT NULL DEFAULT '',
  `identifier` varchar(64) NOT NULL DEFAULT '',
  `paint` varchar(128) DEFAULT NULL,
  `coord` varchar(255) DEFAULT NULL,
  `model` varchar(64) DEFAULT NULL,
  `status` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `don_cars`
  ADD PRIMARY KEY (`plate`);
COMMIT;

CREATE TABLE `vehicle_stock` (
  `id` int(11) NOT NULL,
  `car` varchar(50) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

ALTER TABLE `vehicle_stock`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `vehicle_stock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;