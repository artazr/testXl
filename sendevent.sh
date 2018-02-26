#!/bin/bash

# Send Event to Event Collector

if [ $# -lt 8 ]
then
	echo "Syntax : sendevent.sh -d <MyDomain> -a <MyApplication> -v <MyVersion> -e <MyEventName> -o <MyOptionalParametterName> <MyOPtionnalParameterValue>"
	exit
fi

declare -i i=0
declare -a PARAMETER_NAME
declare -a PARAMETER_VALUE
POSITIONAL=()
while [[ $# -gt 0 ]]
	do
		key="$1"

		case $key in
			-d|--domain)
				DOMAIN="$2"
				shift # past argument
				shift # past value
				;;
			-a|--application)
				APPLINAME="$2"
				shift # past argument
				shift # past value
				;;
			-v|--version)
				APPLIVERSION="$2"
				shift # past argument
				shift # past value
				;;
			-e|--eventType)
				EVENT="$2"
				shift # past argument
				shift # past value
				;;
			-o|--optionnalParameter)
				PARAMETER_NAME[i]="$2"
				PARAMETER_VALUE[i]="$3"
				i+=1
				shift # past argument
				shift # past argument
				shift # past argument
				;;
			*)    # unknown option
				POSITIONAL+=("$1") # save it in an array for later
				shift # past argument
				;;
		esac
done
export NOW="`date +"%Y-%m-%dT%TZ"`"
export SERVERIP="126.246.164.118"
export JSONSTRING="{
        \"domain\":\"${DOMAIN}\",
        \"application\":\"${APPLINAME}\",
        \"version\": \"${APPLIVERSION}\",
        \"timestamp\":\"${NOW}\",
        \"eventType\":\"${EVENT}\",
        \"value\" : {"

#Traitement des paramètres optionnel		
counter=0
initalValue=${#PARAMETER_NAME[@]}
while [[ $counter -lt ${#PARAMETER_NAME[@]} ]]
do
	JSONSTRING=${JSONSTRING}' "'${PARAMETER_NAME[$counter]}'":"'${PARAMETER_VALUE[$counter]}'"'
	((counter++))
	#Gestion de la virgule entre chaque objet
	declare -i result=$((initalValue-counter))
	echo "$result"
	if [[ $result -gt 0 ]]; then
		JSONSTRING=$JSONSTRING","
	fi
done
		
JSONSTRING=$JSONSTRING"}}"

echo $JSONSTRING

#Envoit de la requette HTTP POST au serveur de collecte
curl -v -X POST http://${SERVERIP}/collector -H 'Cache-Control: no-cache' -H 'Content-Type: application/json' -d "${JSONSTRING}"
