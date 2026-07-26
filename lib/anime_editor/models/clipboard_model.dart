import 'drawable_model.dart';


class ClipboardModel {

  List<DrawableModel> items;


  bool hasData;


  bool isCut;


  ClipboardModel({

    this.items = const [],

    this.hasData = false,

    this.isCut = false,

  });



  void copy(List<DrawableModel> drawables) {

    items =
        List<DrawableModel>.from(drawables);

    hasData = items.isNotEmpty;

    isCut = false;

  }



  void cut(List<DrawableModel> drawables) {

    items =
        List<DrawableModel>.from(drawables);

    hasData = items.isNotEmpty;

    isCut = true;

  }



  void clear() {

    items = [];

    hasData = false;

    isCut = false;

  }



  Map<String, dynamic> toJson() {

    return {

      "items":
          items.map((e) => e.toJson()).toList(),

      "hasData": hasData,

      "isCut": isCut,

    };

  }



  factory ClipboardModel.fromJson(
      Map<String, dynamic> json) {

    return ClipboardModel(

      items:
          (json["items"] as List? ?? [])

              .map((e) => DrawableModel.fromJson(e))

              .toList(),


      hasData:
          json["hasData"] ?? false,


      isCut:
          json["isCut"] ?? false,

    );

  }

}