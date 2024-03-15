import 'package:flutter/material.dart';
import 'package:flutter_app/models/prediction.dart';
import 'package:flutter_app/services/prediction_service.dart';

class PredictionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Prediction>>(
      future: PredictionService
          .fetchPredictions(), // This method needs to be implemented in PredictionService
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Prediction prediction = snapshot.data![index];
              return ListTile(
                title: Text(
                    'Longitude: ${prediction.lon}, Latitude: ${prediction.lat}'),
              );
            },
          );
        }
      },
    );
  }
}
