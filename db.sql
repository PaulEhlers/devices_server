CREATE TABLE user (
 user_id INTEGER PRIMARY KEY AUTOINCREMENT,
 fullname TYPE text NOT NULL,
 email TYPE text NOT NULL,
 password TYPE text NOT NULL
); 

CREATE TABLE location (
 location_id INTEGER PRIMARY KEY AUTOINCREMENT,
 street TYPE text NOT NULL,
 name TYPE text NOT NULL,
 postcode TYPE text NOT NULL,
 city TYPE text NOT NULL
); 

CREATE TABLE room (
 room_id INTEGER PRIMARY KEY AUTOINCREMENT,
 name TYPE text NOT NULL,
 location_id TYPE INTEGER,
 FOREIGN KEY(location_id) REFERENCES location(location_id)
); 

CREATE TABLE device (
 device_id INTEGER PRIMARY KEY AUTOINCREMENT,
 type TYPE text NOT NULL,
 setup_date TYPE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 room_id TYPE INTEGER,
 user_id TYPE INTEGER,
 FOREIGN KEY(room_id) REFERENCES room(room_id),
 FOREIGN KEY(user_id) REFERENCES user(user_id)
);