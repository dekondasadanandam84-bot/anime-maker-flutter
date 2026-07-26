class LayerSelectionModel {

  int selectedLayerIndex;

  List<int> selectedLayerIds;


  bool multiSelect;


  LayerSelectionModel({

    this.selectedLayerIndex = 0,

    this.selectedLayerIds = const [],

    this.multiSelect = false,

  });



  void selectLayer(int index) {

    selectedLayerIndex = index;

    if (!multiSelect) {
      selectedLayerIds = [index];
    }

  }



  void toggleLayer(int index) {

    if (selectedLayerIds.contains(index)) {

      selectedLayerIds =
          List<int>.from(selectedLayerIds)
            ..remove(index);

    } else {

      selectedLayerIds =
          List<int>.from(selectedLayerIds)
            ..add(index);

    }

  }



  Map<String, dynamic> toJson() {

    return {

      "selectedLayerIndex": selectedLayerIndex,

      "selectedLayerIds": selectedLayerIds,

      "multiSelect": multiSelect,

    };

  }



  factory LayerSelectionModel.fromJson(
      Map<String, dynamic> json) {

    return LayerSelectionModel(

      selectedLayerIndex:
          json["selectedLayerIndex"] ?? 0,


      selectedLayerIds:
          List<int>.from(
            json["selectedLayerIds"] ?? [],
          ),


      multiSelect:
          json["multiSelect"] ?? false,

    );

  }

}