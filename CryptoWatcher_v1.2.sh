#!/bin/bash
# DEVELOPED BY Di0nJ@ck - January 2018 - v1.2

#************************************************************************************
#DEPENDENCIES: JQ, BC
#GLOBAL VARIABLES
TG_USERID="add your TG user ID here"
tg_bot_key="add your BOT key from TG BotFather here"
tg_bot_url="https://api.telegram.org/bot$tg_bot_key/sendMessage"
CMP_API="https://api.coinmarketcap.com/v1/ticker" #COINMARKETCAP API
#************************************************************************************

#Set font style
set_Font_style{
	RED='\033[0;31m'
	GREEN='\033[0;32m'
	ORANGE='\033[0;33m'
	BLUE='\033[0;34m'
	WHITE='\033[1;37m'
	NC='\033[0m'
	bold=$(tput bold)
	normal=$(tput sgr0)
}

set_Banner{
	banner="

	   _____                  _    __          __   _       _     
	  / ____|                | |   \ \        / /  | |     | |    
	 | |     _ __ _   _ _ __ | |_ __\ \  /\  / /_ _| |_ ___| |__  
	 | |    | \'__| | | | \'_ \| __/ _ \ \/  \/ / _\` | __/ __| \'_ \ 
	 | |____| |  | |_| | |_) | || (_) \  /\  / (_| | || (__| | | |
	  \_____|_|   \__, | .__/ \__\___/ \/  \/ \__,_|\__\___|_| |_|
				   __/ | |                                        
				  |___/|_|             v1.2 @Di0nj@ck (11-01-18)    "                      
}                         

print_Banner{
	echo -e "$banner\n\n"
}

#MAIN
while true
do 
	#Coin - General status
	coin="bitcoin"
	url="${CMP_API}/${coin}/"
	btc_json="$(curl -s ${url})"
	if [ ! "$btc_json" == "" ]; then	
		btc_price="$(echo ${btc_json} | jq -r '.[].price_usd')"
		btc_1h="$(echo ${btc_json} | jq -r '.[].percent_change_1h')"
		btc_1h_int=${btc_1h%.*}
		btc_24h="$(echo ${btc_json} | jq -r '.[].percent_change_24h')"
		btc_24h_int=${btc_24h%.*}
		#POSITIVE OR NEGATIVE TENDENCY
		if (( $(echo "$btc_1h >= 0.0" | bc -l) )); then
			btc_1h_colour="${GREEN}" 
			
		else
			btc_1h_colour="${RED}"
		fi
			
		if (( $(echo "$btc_24h >= 0.0" | bc -l) )); then
			btc_24h_colour="${GREEN}"
		else
			btc_24h_colour="${RED}"
		fi

		#CUSTOMIZED PERCENTAGE CHANGES
		




		#OUTPUT DATA
	
		btc_data="* ${BLUE}${bold}BTC-USD:${NC} ${WHITE}${btc_price}${NC}${normal} USD (${btc_1h_colour}${bold}${btc_1h}%${NC} 1H; ${btc_24h_colour}${bold}${btc_24h}%${NC} 24H) [$(date)]"
		btc_data_tg="* BTC-USD: ${btc_price} USD (${btc_1h}% 1H; ${btc_24h}% 24H) [$(TZ=":CET" date]"
		echo -e "$btc_data"
		curl -s --max-time 10 -d "chat_id=${TG_USERID}&disable_web_page_preview=1&text=${btc_data_tg}" ${tg_bot_url}  > /dev/null
		
	else
		echo -e "* ${BLUE}BTC-USD:${NC} No data available [$(TZ=":CET" date)]"
		
	fi
	sleep 1800 #WAIT 30 MINUTES
done

