import openai
from flask import Flask, request, jsonify

# Set your OpenAI API Key
openai.api_key = "YOUR_OPENAI_API_KEY"

app = Flask(__name__)

@app.route('/get_workout', methods=['POST'])
def get_workout():
    # Get body area from user input
    body_area = request.json.get('body_area')
    
    # Create a prompt for the AI model
    prompt = f"Suggest a list of exercises to target the {body_area} muscle group. Provide a short description for each exercise."
    
    # Send the prompt to OpenAI's API
    response = openai.Completion.create(
        engine="text-davinci-003",  # GPT-3 engine
        prompt=prompt,
        max_tokens=200,
        temperature=0.7
    )
    
    # Get the response from OpenAI
    workout_suggestions = response.choices[0].text.strip()
    
    # Return the workout suggestions to the frontend
    return jsonify({'suggestions': workout_suggestions})

if __name__ == '__main__':
    app.run(debug=True)
