#!/usr/bin/env bash

#Usage info
show_help() {
cat << EOF
Usage: [-g <string>] [-f OUTFILE] [-y <string>] [-m <string>] [-d <string>]
Example of how to find where people have said the word hello on terry on the 1st of feb 2019:
    command -g "SAY:" -g "hello" -n "terry" -y "2019" -m "02" -d "01"

Parameter details:
    -h display this help and exit

    -g specify word you're looking for, can be used multiple times to further filter

    -v specify word to filter out, can be used multiple times

    -n specify any server names to look under, can be used multiple times, non-optional

    -f OUTFILE write the result to OUTFILE as well as standard output

    -y specify the year to search under
    -m specify the month to search under
    -d specify the day to search under
EOF
}

# Initialize
outputFile=""
grepChain=()
grepVChain=()
urlStart="https://tgstation13.org/parsed-logs/"
urlMid="/data/logs/"
urls=()
serverNames=()
year=""
month=""
day=""

OPTIND=1
while getopts ":h:g:v:n:f:y:m:d:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        g)
            grepChain+=($OPTARG)
            ;;
        v)
            grepVChain+=($OPTARG)
            ;;
        n)
            serverNames+=($OPTARG)
            ;;
        f)
            outputFile=$OPTARG
            ;;
        y)
            year=$OPTARG
            ;;
        m)
            month=$OPTARG
            ;;
        d)
            day=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done

# generate urls
for serverName in "${serverNames[@]}"
do
    url="${urlStart}${serverName}${urlMid}"
    if [ "$year" != "" ]
    then
        url+="$year/"
        if [ "$month" != "" ]
        then
            url+="$month/"
            if [ "$day" != "" ]
            then
                url+="$day/"
            fi
        fi
    fi
    urls+=($url)
done

# start scraping
while [ ${#urls[@]} -ne 0 ]
do
    echo "new url: ${urls[0]}"
    content=$(curl -sL "${urls[0]}" | zgrep '')
    paths=(`echo "$content" | grep -Po '(?<=href=")[^"]*'`)

    for word in "${grepChain[@]}"
    do
        content=$(echo "$content" | grep -i "$word")
    done
    for vWord in "${grepVChain[@]}"
    do
        content=$(echo "$content" | grep -iv "$vWord")
    done
    if [ "$outputFile" == "" ]
    then
        echo "$content"
    else
        echo "$content" >> "$outputFile"
    fi
    for path in "${paths[@]}"
    do
        [[ $path == *".zip" || $path == *".."* || $path == *".png" ]] && continue
        [[ $path == *".gz" && $path != *"game.txt.gz" ]] && continue
        urls=( "${urls[0]}" "${urls[0]}$path" "${urls[@]:1}" )
    done
    urls=( "${urls[@]:1}" )
done
