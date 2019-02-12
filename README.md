# tglogscraper
bash log scraper for ss13 tg https://github.com/tgstation/tgstation

# installation
Linux: Download the file and drop it under one of your /bin directories. Rename the file to whatever you'd like the command to be called.
Windows: Get Cygwin, then download the using Cygwin and place under a /bin directory. Rename the file to whatever you'd like the command to be called.

# Usage
Use the -h flag once installed to figure out usage

A complex example:
`./search -E -g "SAY:.*\".*uwu.*\"" -n "terry" -n sybil -y "2019" -v "owo" -v "ghost" -m 02`

Enable regex and look for people saying uwu, ignore people saying owo, ignore ghost chat (but not dead chat). Search only Feb 2019 on terry and sybil
