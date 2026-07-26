class DuplicateModel {

  int count;


  double offsetX;

  double offsetY;


  bool keepTransform;


  bool keepStyle;



  DuplicateModel({

    this.count = 1,


    this.offsetX = 10.0,

    this.offsetY = 10.0,


    this.keepTransform = true,


    this.keepStyle = true,

  });



  Map<String, dynamic> toJson() {

    return {

      "count": count,

      "offsetX": offsetX,

      "offsetY": offsetY,


      "keepTransform": keepTransform,


      "keepStyle": keepStyle,

    };

  }



  factory DuplicateModel.fromJson(
      Map<String, dynamic> json) {

    return DuplicateModel(

      count:
          json["count"] ?? 1,


      offsetX:
          (json["offsetX"] as num?)?.toDouble() ?? 10.0,


      offsetY:
          (json["offsetY"] as num?)?.toDouble() ?? 10.0,


      keepTransform:
          json["keepTransform"] ?? true,


      keepStyle:
          json["keepStyle"] ?? true,

    );

  }

}