from flask import Flask, jsonify # type: ignore
import requests # type: ignore
import geocoder # type: ignore

app = Flask(__name__)

API_KEY = "64eca471f3e4c9abdbdb0fc320bdc263"

def get_location():
    g = geocoder.ip('me')
    if g.latlng:
        return g.latlng[0], g.latlng[1]
    return None, None

def get_weather(lat, lon):
    url = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API_KEY}&units=metric"
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        return {
            "City": data.get("name", "Unknown Location"),
            "Temperature": f"{data['main']['temp']}°C",
            "Humidity": f"{data['main']['humidity']}%",
            "Weather Condition": data["weather"][0]["description"],
            "Wind Speed": f"{data['wind']['speed']} m/s"
        }
    return {"Error": "Could not fetch weather data"}

@app.route('/weather', methods=['GET'])
def weather():
    lat, lon = get_location()
    if lat and lon:
        weather_data = get_weather(lat, lon)
        return jsonify(weather_data)
    return jsonify({"Error": "Could not determine location"})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)

