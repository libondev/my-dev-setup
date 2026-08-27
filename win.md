```sh
# 跳过win自带的curl吊销检查（仍会验证证书链，安全性基本不受影响）
echo "--ssl-no-revoke" >> ~/_curlrc
```