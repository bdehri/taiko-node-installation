# taiko-node-installation

* Öncelikle aşağıdaki satırları ilgili değerleri ekleyerek teker teker çalıştırıyoruz.

```
export L1_ENDPOINT_HTTP=
export L1_ENDPOINT_WS=
export L1_PROVER_PRIVATE_KEY=
```

* Sonrasıda aşağıdaki komutu kullanarak kurulum scriptini makinamıza indiriyoruz.

```
curl -o install.sh https://raw.githubusercontent.com/bdehri/taiko-node-installation/main/install.sh
```

* Scripti makinamıza indirdikten sonra yetkilerini ayarlıyoruz.

```
chmod 777 install.sh
```

* Son olarak scripti aşağıdaki gibi çalıştırıyoruz.

```
./install.sh
```
