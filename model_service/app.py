from flask import Flask, request, jsonify
import pandas as pd
import geopandas as gpd
import numpy as np
import joblib

app = Flask(__name__)

# Load the machine learning model
MODEL_PATH = './model/voting_clf_sknew.joblib'
model = joblib.load(MODEL_PATH)


@app.route('/predict', methods=['POST'])
def predict():
     if 'file' not in request.files or request.files['file'].filename == '':
          return "No file provided", 400
     if request.method == 'POST':
          try:
               # Assume a file is sent with the request
               file = request.files['file']

               if not file:
                    return "No file provided", 400
               
               df = pd.read_csv(file)
               
               # --- Preprocess the data as needed and make predictions ---

               # Select the input features
               input_features = df[['lat', 'lon', 'sst', 'chl']]

               # After the data is ready for prediction
               predictions = model.predict(input_features)

               # Checking the count of 0s and 1s in the predictions
               unique, counts = np.unique(predictions, return_counts=True)
               prediction_counts = dict(zip(unique, counts))
               print("Count of 0s:", prediction_counts.get(0, 0))
               print("Count of 1s:", prediction_counts.get(1, 0))

               # Filter the rows where the prediction is 1
               filtered_data = df[predictions == 1]

               # Round latitude and longitude to two decimal points
               filtered_data['lat'] = filtered_data['lat'].round(1)
               filtered_data['lon'] = filtered_data['lon'].round(1)

               # Remove duplicates
               filtered_data = filtered_data.drop_duplicates(subset=['lat', 'lon'])

               # Create a GeoDataFrame from the filtered data
               gdf = gpd.GeoDataFrame(filtered_data, geometry=gpd.points_from_xy(filtered_data['lon'], filtered_data['lat']), crs="EPSG:4326")

               # Load the Sri Lankan EEZ GeoJSON as a GeoDataFrame
               eez_gdf = gpd.read_file('./assets/sri_lanka_eez.geojson')

               # Load the coastal line polygon GeoJSON as a GeoDataFrame
               coastline_gdf = gpd.read_file('./assets/sri_lanka.json')

               # Check if each point is within the EEZ polygon
               gdf['in_eez'] = gdf.geometry.within(eez_gdf.geometry.unary_union)

               # Create a 1 km buffer around the new coastline
               new_coastline_buffer = coastline_gdf.geometry.unary_union.buffer(0.01)  # Approximately 1 km in decimal degrees

               # Check if each point is within the 1 km buffer
               gdf['in_buffer'] = gdf.geometry.within(new_coastline_buffer)

               # Filter the data to include only points within the EEZ and outside the 1 km buffer
               gdf_filtered = gdf[gdf['in_eez'] & ~gdf['in_buffer']]

               # Save the filtered data to a JSON file
               output_file_path = './outputs/predictions.json'
               gdf_filtered[['lon', 'lat']].to_json(output_file_path, orient='records')
               
               return jsonify({"message": "Predictions saved to outputs/predictions.json"})
          
          except Exception as e:
               return jsonify({"error": str(e)})
          

if __name__ == '__main__':
     app.run(debug=True)