# ecs-menu
Simple bash-made menu to access instances where ECS tasks of services are running.

With this script made in bash with aws-cli commands you will be to access an ECS instance where a container of a specific service in a specific cluster is running.

How to use:

First of all, go and edit the script on the line 9 and change the path to the Key Pair to your own Key Pair name:

```
gnome-terminal -x sh -c "ssh -i ($HOME/.aws/yourKeyPair.pem) ec2-user@$instance_ip"
```

After this change you only need to execute the script with bash:

```
joeltaberne@local:~$ bash ecs_menu.sh 
Retrieving information about your clusters...
1) Cluster1
2) Cluster2
2) Exit
Select a cluster (or exit the ECS menu):
```

You can choose between your clusters or exit the menu.

(Note: If you dont have any clusters or your AWS credentials are wrong you will receive an error message and the menu will exit.)

```
Select a cluster (or exit the ECS menu): 1
Retrieving information about your available services...
1) Service1
2) Service2
3) Service3
4) Exit
Select a service (or exit the ECS menu):
```

Once you select a service, the script will open a new SSH session to the first ECS instance found which has a container of the service you are looking for:

```
Select a service (or exit the ECS menu): 1
You are being connected to an instance containing a container of the service Service1...
```

A new terminal window will open:

```
   __|  __|  __|
   _|  (   \__ \   Amazon Linux 2 (ECS Optimized)
 ____|\___|____/

For documentation, visit http://aws.amazon.com/documentation/ecs
[ec2-user@ip-172-31-2-11 ~]$
```

If you do "docker ps" inside the instance you should be able to see a container of your selected service and the ECS agent container:

```
   __|  __|  __|
   _|  (   \__ \   Amazon Linux 2 (ECS Optimized)
 ____|\___|____/

For documentation, visit http://aws.amazon.com/documentation/ecs
[ec2-user@ip-172-31-2-11 ~]$ docker ps
CONTAINER ID        IMAGE                            COMMAND                   CREATED             STATUS                  PORTS                NAMES
c2f16c74ecc6        joeltf99/hostnamed-http2         "/bin/sh -c 'echo \"<…"   33 minutes ago      Up 33 minutes           0.0.0.0:81->80/tcp   ecs-hostnamed-http-2-httpd-ae8bd48eacf5f6deec01
cb3e26f772b5        amazon/amazon-ecs-agent:latest   "/agent"                  22 hours ago        Up 22 hours (healthy)                        ecs-agent
[ec2-user@ip-172-31-2-11 ~]$
```

You could even enter inside the docker with:

```
docker exec -ti <container_id> bash
```
