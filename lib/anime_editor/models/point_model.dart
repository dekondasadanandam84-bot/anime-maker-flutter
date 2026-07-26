class PointModel {

  double x;

  double y;

  double pressure;

  int timestamp;


  PointModel({

    required this.x,

    required this.y,

    this.pressure = 1.0,

    required this.timestamp,

  });



  Map<String, dynamic> toJson() {

    return {

      "x": x,

      "y": y,

      "pressure": pressure,

      "timestamp": timestamp,

    };
  }



  factory PointModel.fromJson(
      Map<String, dynamic> json) {

    return PointModel(

      x: (json["x"] as num).toDouble(),

      y: (json["y"] as num).toDouble(),


      pressure:
          (json["pressure"] as num?)?.toDouble() ?? 1.0,


      timestamp:
          json["timestamp"] ?? 0,

    );
  }

}