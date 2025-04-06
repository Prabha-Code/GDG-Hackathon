from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import google.generativeai as genai
from googletrans import Translator
import asyncio

app = Flask(__name__)
CORS(app)

# Configure Gemini AI
api_key = "AIzaSyBusmdXcpH2qvFtwH3sSAP6mZq3m1noFu8"  
genai.configure(api_key=api_key)

generation_config = {
    "temperature": 1,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 8192,
    "response_mime_type": "text/plain",
}

model_ai = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    generation_config=generation_config,
)

chat_session = model_ai.start_chat(history=[])
translator = Translator()

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()
    user_message = data.get("message", "").strip()
    user_language = data.get("language", "en")  # Default to English

    if not user_message:
        return jsonify({"response": "Please enter a message."})

    # Translate user message to English for processing
    translated_input = translator.translate(user_message, src=user_language, dest='en')
    translated_input_text = translated_input.text

    # Generate response using AI
    chat_response = chat_session.send_message(translated_input_text)
    ai_response = chat_response.text

    # Translate response back to user's selected language
    translated_output = translator.translate(ai_response, src='en', dest=user_language)
    translated_output_text = translated_output.text

    return jsonify({"response": translated_output_text})

if __name__ == '__main__':
    app.run(debug=True)
