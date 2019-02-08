grepForWord="shardj"
urls=("https://tgstation13.org/parsed-logs/terry/data/logs/2019/02/")
while [ ${#urls[@]} -ne 0 ]
do
    echo "new url: ${urls[0]}"
    content="$(curl -sL "${urls[0]}" | zgrep '')"
    echo "$content" | grep "$grepForWord" | awk '{print "match found: "$0}'
    paths=(`echo "$content" | grep -Po '(?<=href=")[^"]*'`)
    for path in "${paths[@]}"
    do
        [[ $path == *".zip" || $path == *".."* || $path == *".png" ]] && continue
        [[ $path == *".gz" && ${path} != *"game.txt.gz" ]] && continue
        urls=( "${urls[0]}" "${urls[0]}$path" "${urls[@]:1}" )
    done
    urls=( "${urls[@]:1}" )
done
