Geocoder::Configuration.lookup = :google
#Geocoder::Configuration.api_key = "AIzaSyCFREOloLh2CTRpELzzGJJSEPV-LKyAfjY"
Geocoder::Configuration.api_key = ""
Geocoder::Configuration.timeout = 5
Geocoder::Configuration.use_https = false
Geocoder::Configuration.language = :de
#Geocoder::Configuration.cache = Redis.new

Geokit::Geocoders::google = ""