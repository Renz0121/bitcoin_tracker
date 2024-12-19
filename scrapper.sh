#! /bin/bash

url="https://www.coindesk.com/price/bitcoin"
outputfile="bitcoin.txt"

function get_webpage_html() {
    curl -o $outputfile $url
    check_error
}

function get_bitcoin_price(){
    suffix=" USD"
    btc_price= grep -oP '(?<=<span class="Noto_Sans_2xl_Sans-700-2xl text-color-black ">).*?(?=</span>)' "bitcoin.txt" | sed -e "s/$suffix$//"
    echo $btc_price
}

function get_crypto_currency_values(){
    crypto_currency_values= grep -oP '(?<=<span class="Noto_Sans_xs_Sans-600-xs text-color-black ">).*?(?=</span>)' bitcoin.txt | sed 's/<[^>]*>//g' | grep "^[A-Z]"S
    echo $crypto_currency_values
}

# function get_day_low(){

# }
# check for any errors when getting the web page

function check_error() {
    [ $? -ne 0 ] && echo "Error while getting web page" $$ exit -1
}

function insert_to_database(){
    current_time=$(date +"%T")
    c_values=$(get_crypto_currency_values)
    date=$(date '+%Y-%m-%d')
    for c_value in $c_values
    do
    coin_name=$(echo $c_value | grep -oP "^[A-Z]+")
    coin_price=$(echo $c_value | grep -oP "[0-9,]+[.][0-9]+")
    coin_price_diff=$(echo $c_value | grep -oP "[+-][0-9.]+%")
    $($(/opt/lampp/bin/mysql -u root -e "use crypto_db; insert into crypto_table values ('$coin_name','$date','$time','$coin_price','$coin_price_diff')")
    done
}

insert_to_database

