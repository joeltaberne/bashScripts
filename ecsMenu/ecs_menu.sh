#!/bin/bash

function connect_to_instance { 
echo "You are being connected to an instance containing a container of the service $service_name ..."
task=$(aws ecs list-tasks --cluster $cluster_name --query "taskArns[0]" --service-name $service_name --output text)
container_instance=$(aws ecs describe-tasks --cluster $cluster_name --query "tasks[*].containerInstanceArn" --tasks $task --output text)
instance=$(aws ecs describe-container-instances --cluster $cluster_name --query "containerInstances[*].ec2InstanceId" --container-instances $container_instance --output text)
instance_ip=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicIpAddress" --instance $instance --output text)
gnome-terminal -x sh -c "ssh -i $HOME/.aws/yourKeyPair.pem ec2-user@$instance_ip"
}

options_clusters=( "$@" )

echo "Retrieving information about your clusters..."
number_of_clusters=$(aws ecs list-clusters --output text | wc -l)
if [ $number_of_clusters -eq 0 ]
then
    echo ""
    echo "No clusters available, please check your resources and/or AWS credentials."
    exit
else
    for i in $(seq 0 "$((number_of_clusters-1))")
    do
        cluster_arn=$(aws ecs list-clusters --query "clusterArns[$i]" --output text)
        cluster_name=$(aws ecs describe-clusters --cluster $cluster_arn --query "clusters[*].clusterName" --output text)
        options_clusters+=("$cluster_name")
    done
fi

options_clusters+=("Exit")

PS3='Select a cluster (or exit the ECS menu): '
select opt in "${options_clusters[@]}"
do
    case $opt in
        "Exit")
            exit
            ;;
        "${options_clusters[$((REPLY-1))]}")
            cluster_name=${options_clusters[$((REPLY-1))]}
            break
            ;;
        *) echo "Invalid option $REPLY, please try again:";;
    esac
done

options_services=( "$@" )

echo "Retrieving information about your available services..."
number_of_services=$(aws ecs list-services --cluster $cluster_name --output text | wc -l)
if [ $number_of_services -eq 0 ]
then
    echo ""
    echo "No services available in cluster $cluster_name, please check your resources and/or AWS credentials."
    exit
else
    for i in $(seq 0 "$((number_of_services-1))")
    do
        service_arn=$(aws ecs list-services --query "serviceArns[$i]" --cluster $cluster_name --output text)
        service_name=$(aws ecs describe-services --cluster $cluster_name --query "services[*].serviceName" --services $service_arn --output text)
        options_services+=("$service_name")
    done
fi

options_services+=("Exit")

PS3='Select a service (or exit the ECS menu): '
select opt in "${options_services[@]}"
do
    case $opt in
        "Exit")
            exit
            ;;
        "${options_services[$((REPLY-1))]}")
            service_name=${options_services[$((REPLY-1))]}
            connect_to_instance
            break
            ;;
        *) echo "Invalid option $REPLY, please try again";;
    esac
done