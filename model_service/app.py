from flask import Flask, request, jsonify
import pandas as pd
import joblib
# from io import StringIO
import os

app = Flask(__name__)

# Load the machine learning model
MODEL_PATH = './model/RandomForest3.joblib'
model = joblib.load(MODEL_PATH)


@app.route('/predict', methods=['POST'])
def predict():
     if request.method == 'POST':
          try:
               # Assume a file is sent with the request
               file = request.files['file']#.read().decode('utf-8')

               if not file:
                    return "No file provided", 400
               
               # df = pd.read_csv(StringIO(file))
               df = pd.read_csv(file)
               
               # --- Preprocess the data as needed and make predictions ---

               # Convert 'date' column to 'dayofyear'
               df['dayofyear'] = pd.to_datetime(df['date']).dt.dayofyear
               # Drop the original 'date' column
               df.drop(columns=['date'], inplace=True)

               # After the data is ready for prediction
               predictions = model.predict(df)

               output_file_path = './outputs/predictions.json'
               df['prediction'] = predictions
               good_spots = df[df['prediction'] == 1]
               good_spots[['lon', 'lat']].to_json(output_file_path, orient='records')
               
               return jsonify({"message": "Predictions saved to outputs/predictions.json"})
          
          except Exception as e:
               return jsonify({"error": str(e)})
          

if __name__ == '__main__':
     app.run(debug=True)