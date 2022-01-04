#!/bin/bash
# 
################################################################################
#
#  © Copyright 2017 Alban Vidal
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
# 
################################################################################
#
#  © Copyright 2017 Alban Vidal
#    Autorisé sous la licence d'Apache, version 2,0 (la « Licence ») ;
#    vous ne pouvez pas employer ce fichier excepté conformément a la licence.
#    Vous pouvez obtenir une copie de la licence à l'adresse suivante
# 
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    À moins que requis par loi applicable ou été d'accord sur par écrit, logiciel
#    distribué sous le permis est distribué sur « DE MÊME QUE » la BASE,
#    SANS GARANTIES OU ÉTATS DE LA SORTE, exprès ou implicite.
#    Voyez la licence pour les autorisations gouvernelentales de langue spécifique
#    et limitations sous la licence.
#
################################################################################
#
# By Alban Vidal <alban.vidal@zordhak.fr>
#
# Creation date	2017-06-12
# Update date	2017-11-04
#
# version 0.12
#
################################################################################
#
#                              --- Return code ---
#
# 0  : OK, print JSON or CSV format
# 1  : Cache file is not writable
# 2  : Access deny to create cache file / please check rights or change path to cache file
# 3  : Format error
# 4  : Transfer failed
# 5  : Result is empty
# 6  : Tempory file is empty, please use --force option to reload cache
# 7  : incorrect CSV output type
# 8  : ERROR: "--host" requires a non-empty option argument
# 99 : Options error
#
################################################################################
#
#                            --- START SET USER VARS ---
#
#                             You can edit value below:

# Define seach zones :
#_SEARCH_ZONE_="domain1.example.com domain2.example.com"
_SEARCH_ZONE_="k3s.mobilelife.de mobilelife.de" ## DEV ONLY

# define tempory file (cache file) to store results :
_CACHE_FILE_="/tmp/dns-inventory_$USER.tmp"

# define time to keep previous cache (TTL) in seconds :
# 60    = 1 minute
# 600   = 10 minute < Recommended value
# 3600  = 1 hour
# 86400 = 1 day
_CACHE_TTL_="600"
#
#                             --- END SET USER VARS ---
################################################################################
#
#                           --- START SET PROGRAM VARS ---
#
#                               !!! DO NOT MODIFY !!! 
#
# default output format is json :
FORMAT='json'
#
# Output type : all / list / host
# all :print all
# list : print list of hosts
# host XXX : print host XXX vars
TYPE='all'
#
# if true, disable querry and not use cache
FORCE=false
#
# HOST is value of « --host HOST » argument
HOST=''
#
#                           --- END SET PROGRAM VARS ---
################################################################################

# Print help (usage)
function usage()
{
    echo -e ""
    echo -e "Usage: $0 [OPTIONS]"
    echo -e ""
    echo -e "[OPTIONS] :"
    echo -e "  --list  | -l            ------------> default option, print to json format (needed to ansible)"
    echo -e "  --force | -f            ------------> force querry, reload the cache"
    echo -e "  --csv   | -c            ------------> print output to csv - i.e : key1;\"value1\""
    echo -e "  --host  | -o [HOSTNAME] ------------> print host vars"
    echo -e "  --help  | -h            ------------> print help and quit"

} # end usage()

# Create a new querry do dns / if temeout or --force option
function querry()
{
    # Create OR Clear cache file :
    if ! > "$_CACHE_FILE_" 
    then
        >&2 echo "ERROR: Access deny to create cache file: $_CACHE_FILE_"
        >&2 echo "ERROR: Please check rights or change path to cache file"
        exit 2
    fi
    
    # dig to DNS server
    DNS_DATA=$(dig axfr $_SEARCH_ZONE_) # all result
    DNS_TXT=$(echo $DNS_DATA|grep TXT)  # just TXT result
    # and test if result is failed
    if echo "$DNS_DATA"|grep 'Transfer failed' > /dev/null
    then
        >&2 echo "ERROR: Transfer failed"
        >&2 echo "Please check if \$_SEARCH_ZONE_ is set correctly and if you have a right to transfert zone"
        >&2 echo "Current \$_SEARCH_ZONE_ value :"
        >&2 echo "$_SEARCH_ZONE_"
        exit 4
    # OR if result is empty :
    elif [ -z "$DNS_TXT" ]
    then
        >&2 echo "ERROR: Result is empty !"
        >&2 echo "Current \$_SEARCH_ZONE_ value :"
        >&2 echo "$_SEARCH_ZONE_"
        exit 5
    else
        echo "$DNS_DATA" |grep TXT|awk '{print $1";"$5}' > "$_CACHE_FILE_"
    fi

} # end querry()

# Print output in json format :
function output_json()
{
    # Initialise Array :
    declare -A RETURN

    while read DNS
    do
        SRV=$(echo $DNS|awk -F ';' '{print $1}'|sed 's/\.$//')
        TXT=$(echo $DNS|awk -F ';' '{print $2}')

        if [ ${RETURN[$TXT]} ]
        then
            RETURN[$TXT]="${RETURN[$TXT]},\"$SRV\""
        else
            RETURN[$TXT]="\"$SRV\""
        fi

    done < "$_CACHE_FILE_"

    echo '{'

    for KEY in ${!RETURN[@]} # BOUCLE SUR LES CLES
    do

         echo "
            $KEY: {
                \"hosts\": [ ${RETURN[$KEY]} ]
            },
        "

    done

    echo '}'

} # end output_json()

# Print output in csv format :
function output_csv()
{
        case $TPYE in
            "list")
#echo "output_csv:list"
                while read DNS
                do
 
                    SRV=$(echo $DNS|awk -F ';' '{print $1}'|sed 's/\.$//')
                    TXT=$(echo $DNS|awk -F ';' '{print $2}')

#echo "$TXT"
                if echo "$TXT"|grep -E '^"vars=' > /dev/null
                then
#echo "VARS"
                    continue
                fi


                    echo "$SRV;$TXT"
                done < "$_CACHE_FILE_"

            ;;

            "host")

#echo "output_csv:host"
                grep -E "$HOST.*vars=" "$_CACHE_FILE_"

            ;;

            "all") # default option
                cat "$_CACHE_FILE_"
            ;;
 

            *)

# no more used, default case is « all »
# on est dans le cas all, donc on peut afficher tel quel
                >&2 echo "ERROR: incorrect CSV output type"
                >&2 echo "Please specify --list or --host option"
                exit 7

            ;;
        esac




} # end output_csv()


function main()
{

    # if cache file exist, test if is writable :
    if [ -f "$_CACHE_FILE_" ] && [ ! -w "$_CACHE_FILE_" ]
    then
        >&2 echo "ERROR: Cache file $_CACHE_FILE_ is not writable !"
        exit 1
    fi
        
    # test TTL cache file :
    # if file not exist AND -f options is not set, force querry
    if ([ -f "$_CACHE_FILE_" ] && ! $FORCE )
    then
        modsecs=$(date --utc --reference="$_CACHE_FILE_" +%s)
        nowsecs=$(date +%s)
        delta=$(($nowsecs-$modsecs))
    else
        delta=$_CACHE_TTL_ # set same value to force querry
    fi

    # test if use cache or create new DNS querry :
    if [ ! $delta -lt $_CACHE_TTL_ ]
    then
        querry # call « querry » function 
    fi

    # Test if tempory file is empty :
    if [ ! -s "$_CACHE_FILE_" ]
    then
        >&2 echo "ERROR: Tempory file is empty, please use --force option to reload cache"
        exit 6
    fi 

    if [ $FORMAT == 'json' ]
    then
        output_json # call json function to read data and print to stdout
    elif [ $FORMAT == 'csv' ]
    then
        output_csv # call csv function ro read data and print to stdout
    else
        >&2 echo "ERROR: format error"
        exit 3
    fi


} # end main()

################################################################################
#
#                         --- Start check options ---
while : 
do
    case $1 in
        -h|-\?|--help)
            # print help
            usage
            exit 0
            ;;
        -f|--force)
            # force
            FORCE=true
            ;;
        -c|--csv)
            # output to csv format
            FORMAT='csv'
#echo "CSV"
            ;;
        -l|--list)
            # required for ansible, ansible call this script whith --list option
            # ansible need JSON format
            TPYE='list'
#echo "list"
            ;;
        -o|--host)
            # COMMING SOON !
            TPYE='host'
            
            if [ -n "$2" ]; then
                HOST="$2"
#echo "HOST:$HOST"
                shift
            else
                >&2 echo 'ERROR: "--host" requires a non-empty option argument'
                exit 8
            fi
#
# When called with the arguments --host <hostname> (where <hostname> is a host from above), the script must print either an empty JSON 
# hash/dictionary, or a hash/dictionary of variables to make available to templates and playbooks. Printing variables is optional, if the script does not 
# wish to do this, printing an empty hash/dictionary is the way to go:
# {
#    "favcolor": "red",
#    "ntpserver": "wolf.example.com",
#    "monitoring": "pack.example.com"
# }
#
#            exit 0
            ;;
        --)
            shift
            break
            ;;
        -?*)
            >&2 echo "Unknown option: $1"
            usage
            exit 99
            ;;
        *)
            break
    esac
    shift
done
#
# see http://docs.ansible.com/ansible/dev_guide/developing_inventory.html
# to --list and --host option
# 
#                         --- End check options ---
#
################################################################################
#
#                           call « main » function
main 
#
#
################################################################################