##### nitroarch@~/kood/crud-master(git✱master)✔≻ vagrant status

```
Current machine states:

gateway                   running (virtualbox)
inventory                 running (virtualbox)
billing                   running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run
```

##### nitroarch@~/kood/crud-master(git✱master)✔≻ curl -X POST -H "Content-Type: application/json" -d '{"title":"The Matrix", "description":"A computer programmer discovers a dystopian world"}' http://192.168.56.10:3000/movies/

```
{"id":1,"title":"The Matrix","description":"A computer programmer discovers a dystopian world","updatedAt":"2024-10-16T12:10:10.504Z","createdAt":"2024-10-16T12:10:10.504Z"}⏎
```
                                                       
##### nitroarch@~/kood/crud-master(git✱master)✔≻ curl http://192.168.56.10:3000/movies/
```
[{"id":1,"title":"The Matrix","description":"A computer programmer discovers a dystopian world","createdAt":"2024-10-16T12:10:10.504Z","updatedAt":"2024-10-16T12:10:10.504Z"}]
```                                                      
##### nitroarch@~/kood/crud-master(git✱master)✔≻ vagrant ssh inventory
```
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-193-generic x86_64)
```
##### vagrant@inventory:~$ sudo -i -u postgres psql

```
psql (12.20 (Ubuntu 12.20-0ubuntu0.20.04.1))
Type "help" for help.

postgres=# \l
                              List of databases
   Name    |  Owner   | Encoding | Collate |  Ctype  |   Access privileges   
-----------+----------+----------+---------+---------+-----------------------
 inventory | postgres | UTF8     | C.UTF-8 | C.UTF-8 | =Tc/postgres         +
           |          |          |         |         | postgres=CTc/postgres+
           |          |          |         |         | rabbit=CTc/postgres
 postgres  | postgres | UTF8     | C.UTF-8 | C.UTF-8 | 
 template0 | postgres | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
           |          |          |         |         | postgres=CTc/postgres
 template1 | postgres | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
           |          |          |         |         | postgres=CTc/postgres
(4 rows)
```

##### inventory=# bye
##### inventory-# exit
```
Use \q to quit.
```
##### inventory-# \q

##### vagrant@inventory:~$ sudo -i -u postgres psql -d inventory -c 'COPY (SELECT * FROM movies) TO STDOUT WITH CSV HEADER'
    id,title,description,createdAt,updatedAt
    1,The Matrix,A computer programmer discovers a dystopian world,2024-10-16 12:10:10.504+00,2024-10-16 12:10:10.504+00
##### vagrant@inventory:~$ exit
```
logout
```

##### nitroarch@~/kood/crud-master(git✱master)✔≻ vagrant ssh billing
```
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-193-##### generic x86_64)
vagrant@billing:~$ sudo pm2 list
┌────┬────────────────────┬──────────┬──────┬───────────┬──────────┬──────────┐
│ id │ name               │ mode     │ ↺    │ status    │ cpu      │ memory   │
├────┼────────────────────┼──────────┼──────┼───────────┼──────────┼──────────┤
│ 1  │ billing            │ fork     │ 0    │ online    │ 0%       │ 67.9mb   │
│ 0  │ consumer           │ fork     │ 0    │ online    │ 0%       │ 62.4mb   │
└────┴────────────────────┴──────────┴──────┴───────────┴──────────┴──────────┘
```

##### vagrant@billing:~$ curl -X POST -H "Content-Type: application/json" -d '{"user_id": "20", "number_of_items": "52", "total_amount": "142"}' http://192.168.56.10:3000/billing/
```
Order received and sent to queue.
```
##### vagrant@billing:~$ sudo pm2 start consumer
```
[PM2] Applying action restartProcessId on app [consumer](ids: [ 0 ])
[PM2] [consumer](0) ✓
[PM2] Process successfully started
┌────┬────────────────────┬──────────┬──────┬───────────┬──────────┬──────────┐
│ id │ name               │ mode     │ ↺    │ status    │ cpu      │ memory   │
├────┼────────────────────┼──────────┼──────┼───────────┼──────────┼──────────┤
│ 1  │ billing            │ fork     │ 1    │ online    │ 0%       │ 66.4mb   │
│ 0  │ consumer           │ fork     │ 3    │ online    │ 0%       │ 27.5mb   │
└────┴────────────────────┴──────────┴──────┴───────────┴──────────┴──────────┘
```
##### vagrant@billing:~$ sudo -i -u postgres psql -d billing -c 'COPY (SELECT * FROM public.orders) TO STDOUT WITH CSV HEADER'
```
id,user_id,number_of_items,total_amount
45671,20,52,142.00
45679,20,52,142.00
45680,20,52,142.00
45686,20,52,142.00
```
##### vagrant@billing:~$ sudo pm2 stop consumer
```
[PM2] Applying action stopProcessId on app [consumer](ids: [ 0 ])
[PM2] [consumer](0) ✓
┌────┬────────────────────┬──────────┬──────┬───────────┬──────────┬──────────┐
│ id │ name               │ mode     │ ↺    │ status    │ cpu      │ memory   │
├────┼────────────────────┼──────────┼──────┼───────────┼──────────┼──────────┤
│ 1  │ billing            │ fork     │ 1    │ online    │ 0%       │ 67.2mb   │
│ 0  │ consumer           │ fork     │ 3    │ stopped   │ 0%       │ 0b       │
└────┴────────────────────┴──────────┴──────┴───────────┴──────────┴──────────┘
```
##### vagrant@billing:~$ sudo -i -u postgres psql -d billing -c 'COPY (SELECT * FROM public.orders) TO STDOUT WITH CSV HEADER'
```
id,user_id,number_of_items,total_amount
45671,20,52,142.00
45679,20,52,142.00
45680,20,52,142.00
45686,20,52,142.00
```
##### vagrant@billing:~$ curl -X POST -H "Content-Type: application/json" -d '{"user_id": "20", "number_of_items": "52", "total_amount": "142"}' http://192.168.56.10:3000/billing/
```
Order received and sent to queue.
```
##### vagrant@billing:~$ curl -X POST -H "Content-Type: application/json" -d '{"user_id": "20", "number_of_items": "52", "total_amount": "142"}' http://192.168.56.10:3000/billing/
```
Order received and sent to queue.
```
##### vagrant@billing:~$ sudo -i -u postgres psql -d billing -c 'COPY (SELECT * FROM public.orders) TO STDOUT WITH CSV HEADER'
```
id,user_id,number_of_items,total_amount
45671,20,52,142.00
45679,20,52,142.00
45680,20,52,142.00
45686,20,52,142.00
```
##### vagrant@billing:~$ sudo pm2 start consumer
```
[PM2] Applying action restartProcessId on app [consumer](ids: [ 0 ])
[PM2] [consumer](0) ✓
[PM2] Process successfully started
┌────┬────────────────────┬──────────┬──────┬───────────┬──────────┬──────────┐
│ id │ name               │ mode     │ ↺    │ status    │ cpu      │ memory   │
├────┼────────────────────┼──────────┼──────┼───────────┼──────────┼──────────┤
│ 1  │ billing            │ fork     │ 1    │ online    │ 0%       │ 67.2mb   │
│ 0  │ consumer           │ fork     │ 3    │ online    │ 0%       │ 748.0kb  │
└────┴────────────────────┴──────────┴──────┴───────────┴──────────┴──────────┘
```
##### vagrant@billing:~$ sudo -i -u postgres psql -d billing -c 'COPY (SELECT * FROM public.orders) TO STDOUT WITH CSV HEADER'
```
id,user_id,number_of_items,total_amount
45671,20,52,142.00
45679,20,52,142.00
45680,20,52,142.00
45686,20,52,142.00
45693,20,52,142.00
45695,20,52,142.00
```
##### vagrant@billing:~$ exit
```
logout
```
