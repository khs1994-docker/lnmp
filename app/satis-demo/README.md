# Composer 私有化解决方案 Satis

* 问题反馈 https://github.com/khs1994-docker/lnmp/issues/479

* https://github.com/composer/satis

* https://getcomposer.org/doc/articles/handling-private-packages.md#satis

## GitHub API 等的频率限制

```bash
Could not fetch https://api.github.com/repos/khs1994-docker/libdocker, please create a GitHub OAuth token to go over the API rate limit
Head to https://github.com/settings/tokens/new?scopes=repo&description=Composer+on+7b6ead567709+2018-05-29+1134
to retrieve a token. It will be stored in "/composer/auth.json" for future use by Composer.
Token (hidden):
```

加上 `token` 解除限制

* https://getcomposer.org/doc/articles/troubleshooting.md#api-rate-limit-and-oauth-tokens

生成 `token` 之后，在提示处粘贴 `token` 回车即可。
