import joblib
import pandas as pd
from flask import Flask, request, jsonify

# Load the model and training columns
model = joblib.load('crop_production_model.pkl')
training_columns = joblib.load('training_columns.pkl')

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    # Get data from the request
    data = request.get_json()

    # Input parameters
    state = data.get('State_Name')
    district = data.get('District_Name')
    season = data.get('Season')
    crop = data.get('Crop')
    area = data.get('Area')

    # Create a DataFrame for the input
    input_data = pd.DataFrame([[state, district, season, crop, area]],
                              columns=['State_Name', 'District_Name', 'Season', 'Crop', 'Area'])

    # One-hot encode the input data to match training format
    input_encoded = pd.get_dummies(input_data, columns=['State_Name', 'District_Name', 'Season', 'Crop'])

    # Align columns with training data (fill missing ones with 0)
    input_encoded = input_encoded.reindex(columns=training_columns, fill_value=0)

    # Predict
    predicted_production = model.predict(input_encoded)

    # Convert to Python float (for JSON serialization)
    final_prediction = abs(float(predicted_production[0]))  # Convert to float and take absolute value

    # Return the result as JSON
    return jsonify({"Predicted Production": round(final_prediction, 2)})

if __name__ == "__main__":
    app.run(debug=True)
