# CHANGELOG

* Please use `$ docker buildx build xxx` build image, Docker 19.03+
* Resupport `5.6` `7.0`
* Add `nightly-TYPE-alpine`, build from php-src git
* Support buildkit

## 8.4

### Remove ext/imap — it has been moved to PECL

* https://hub.nuaa.cf/php/php-src/commit/f62f6a6d4b9567530775d684db55e9990952c737
* https://hub.nuaa.cf/php/php-src/commits/master/ext/imap

### PSpell has been moved to PECL

* https://hub.nuaa.cf/php/php-src/commit/b035cb6c8e31bea351f169b3e9f34fdc562e77e1
* https://hub.nuaa.cf/php/php-src/commits/master/ext/pspell

## docker image ftp ext removed

* 8.3.2(removed)
* 8.2.15(removed)
* 8.1.28(removed)
