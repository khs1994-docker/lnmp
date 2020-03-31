# 加解密文件

```bash
$ openssl enc -aes-128-cbc -e -a -in FILE_PATH -out OUT_FILE_PATH -K c286696d887c9aa0611bbb3e2025a400 -iv 562e17996d093d28ddb3ba695a2e6f00

$ openssl enc -aes-128-cbc -d -a -in FILE_PATH -out OUT_FILE_PATH -K c286696d887c9aa0611bbb3e2025a400 -iv 562e17996d093d28ddb3ba695a2e6f00
```
