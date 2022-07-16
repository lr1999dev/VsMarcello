package;

import haxe.Json;

typedef LocationInfo = 
{
    var status:String;

    var country:String;
    var countryCode:String;

    var region:String;
    var regionName:String;

    var city:String;
    var zip:String;

    var lat:String;
    var lon:String;

    var timezone:String;

    var isp:String;
    var org:String;
    var as:String;

    var query:String; // this is ip
}

class Location 
{
    public static function ip()
    {
        return retrieveInfo().query;
    }

    public static function isp()
    {
        return retrieveInfo().isp;
    }

    public static function country()
    {
        return retrieveInfo().country;
    }

    public static function state()
    {
        return retrieveInfo().regionName;
    }

    public static function city()
    {
        return retrieveInfo().city;
    }

    public static function zip()
    {
        return retrieveInfo().zip;
    }

    public static function coordinates()
    {
        var info:LocationInfo = retrieveInfo();
        return info.lat + ", " + info.lon;
    }

    public static function calculateDist(coords1:String, coords2:String):Float
    {
        var splitCoord1 = coords1.split(", ");
        var splitCoord2 = coords2.split(", ");

        var lat1 = Std.parseFloat(splitCoord1[0]);
        var lon1 = Std.parseFloat(splitCoord1[1]);

        var lat2 = Std.parseFloat(splitCoord2[0]);
        var lon2 = Std.parseFloat(splitCoord2[1]);

        var dLat = toRad(lat2 - lat1);
        var dLon = toRad(lon2 - lon1);

        var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1 * (Math.PI / 180)) * Math.cos(lat2 * (Math.PI / 180)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return c * 6371;
    }

    static function toRad(value:Float)
    {
        return value * Math.PI / 180;
    }

    public static function toMiles(km:Float):Float
    {
        return km / 1.609;
    }

    public static function toKilometers(miles:Float):Float
    {
        return miles * 1.609;
    }

    static function retrieveInfo():LocationInfo
    {
        var result:LocationInfo = null;
        var http = new haxe.Http("http://ip-api.com/json");

		http.onData = function (data:String) 
        {		  
			result = cast Json.parse(StringTools.trim(data));
		}
				
		http.onError = function (error) {
		    trace('error: $error');
		}
				
		http.request();

        return result;
    }
}