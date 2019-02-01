---
layout: post
title: 使用脚本备份还原 postgresql
category: tech
tags: postgresql
---
![](https://cdn.kelu.org/blog/tags/postgresql.jpg)

# 定期备份

	#!/bin/sh
	. /etc/profile
	
	dt=$(date +%Y-%m-%d-%H%M)
	pg_dump -F c -Z 9 -d exampleDb > /var/local/pg_dump/exampleDb.all.$dt.dump

# 还原

	pg_restore -d exampleDb exampleDb.all.dump

# 服务器迁移还原脚本

	sudo -u postgres bash -c "psql -c \"ALTER USER postgres WITH PASSWORD 'postgres';\""
	sudo -u postgres bash -c "psql -c \"CREATE USER exampleDb WITH PASSWORD 'exampleDb';\""
	sudo -u postgres bash -c "psql -c \"CREATE DATABASE exampleDb OWNER exampleDb;\""
	sudo -u postgres bash -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE exampleDb to exampleDb;\""
	cp postgresql.conf /etc/postgresql/9.4/main
	cp pg_hba.conf /etc/postgresql/9.4/main
	sudo -u postgres pg_restore -d exampleDb exampleDb.all.dump
