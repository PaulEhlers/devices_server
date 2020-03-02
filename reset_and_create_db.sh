#!/bin/bash
rm db/devices.db
sqlite3 db/devices.db < db.sql