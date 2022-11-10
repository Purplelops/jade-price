extends Control

onready var http = $HTTPRequest

var json

var sell_price
var sell_price_gold
var sell_price_silver
var sell_price_copper

var sell_price_10_gold
var sell_price_10_silver
var sell_price_10_copper

#var buy_price
#var buy_price_gold
#var buy_price_silver
#var buy_price_copper

var amount

func _ready():
	http.request("https://api.guildwars2.com/v2/commerce/prices/97102")



func _on_HTTPRequest_request_completed(_result, _response_code, _headers, body):
	json = JSON.parse(body.get_string_from_utf8())
	sell_price = int(json.result["sells"]["unit_price"])
	#buy_price = int(json.result["buys"]["unit_price"])



func get_prices(sell_price_t, sell_10_price):
	sell_price_gold = sell_price_t / 10000
	sell_price_silver = (sell_price_t / 100) - sell_price_gold * 100
	sell_price_copper = sell_price_t - sell_price_silver * 100 - sell_price_gold * 10000
	
	sell_price_10_gold = floor(sell_10_price / 10000)
	sell_price_10_silver = floor((sell_10_price / 100) - sell_price_10_gold * 100)
	sell_price_10_copper = floor(sell_10_price - sell_price_10_silver * 100 - sell_price_10_gold * 10000)
	
	#buy_price_gold = buy_price / 10000
	#buy_price_silver = (buy_price / 100) - buy_price_gold * 100
	#buy_price_copper = buy_price - buy_price_silver * 100 - buy_price_gold * 10000



func _on_LineEdit_text_changed(new_text):
	amount = int(new_text)
	var temp_price = sell_price * amount
	var temp_10_price = ceil(sell_price * amount * 0.9)
	#buy_price = int(json.result["buys"]["unit_price"])
	get_prices(temp_price, temp_10_price)
	update_labels()



func update_labels():
	$Priser/PrisGold.text = str(sell_price_gold)
	$Priser/PrisSilver.text = str(sell_price_silver)
	$Priser/PrisCopper.text = str(sell_price_copper)
	
	$Priser/Pris10Gold.text = str(sell_price_10_gold)
	$Priser/Pris10Silver.text = str(sell_price_10_silver)
	$Priser/Pris10Copper.text = str(sell_price_10_copper)
