from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import joblib
import numpy as np

# Load model and encoders
final_model = joblib.load('commodity_price_model.pkl')
label_encoders = joblib.load('label_encoders.pkl')

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    return render_template('index.html')  # serve the HTML form

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.json
        required_fields = ['State', 'District', 'Market', 'Commodity', 'Variety']
        
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing field: {field}"}), 400

        # Encode input values
        try:
            state_encoded = label_encoders['State'].transform([data['State']])[0]
            district_encoded = label_encoders['District'].transform([data['District']])[0]
            market_encoded = label_encoders['Market'].transform([data['Market']])[0]
            commodity_encoded = label_encoders['Commodity'].transform([data['Commodity']])[0]
            variety_encoded = label_encoders['Variety'].transform([data['Variety']])[0]
        except ValueError as ve:
            return jsonify({"error": f"Encoding error: {str(ve)}"}), 400

        # Derived features
        state_market_encoded = state_encoded * 1000 + market_encoded
        commodity_variety_encoded = commodity_encoded * 1000 + variety_encoded

        sample_input = np.array([[state_encoded, district_encoded, market_encoded,
                                  commodity_encoded, variety_encoded, state_market_encoded,
                                  commodity_variety_encoded]])

        prediction = final_model.predict(sample_input)
        min_price, max_price, modal_price = prediction[0]

        return jsonify({
            "Min Price": round(float(min_price), 2),
            "Max Price": round(float(max_price), 2),
            "Modal Price": round(float(modal_price), 2)
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
