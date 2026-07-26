class HistoryModel {

  List<Map<String, dynamic>> undoStack;

  List<Map<String, dynamic>> redoStack;


  int maxHistory;


  bool enabled;



  HistoryModel({

    this.undoStack = const [],

    this.redoStack = const [],


    this.maxHistory = 100,


    this.enabled = true,

  });



  void addHistory(Map<String, dynamic> state) {

    if (!enabled) return;


    undoStack =
        List<Map<String, dynamic>>.from(undoStack)
          ..add(state);


    if (undoStack.length > maxHistory) {

      undoStack.removeAt(0);

    }


    redoStack = [];

  }



  Map<String, dynamic>? undo() {

    if (undoStack.isEmpty) return null;


    final state = undoStack.last;


    undoStack =
        List<Map<String, dynamic>>.from(undoStack)
          ..removeLast();


    redoStack =
        List<Map<String, dynamic>>.from(redoStack)
          ..add(state);


    return state;

  }



  Map<String, dynamic>? redo() {

    if (redoStack.isEmpty) return null;


    final state = redoStack.last;


    redoStack =
        List<Map<String, dynamic>>.from(redoStack)
          ..removeLast();


    undoStack =
        List<Map<String, dynamic>>.from(undoStack)
          ..add(state);


    return state;

  }



  Map<String, dynamic> toJson() {

    return {

      "undoStack": undoStack,

      "redoStack": redoStack,

      "maxHistory": maxHistory,

      "enabled": enabled,

    };

  }



  factory HistoryModel.fromJson(
      Map<String, dynamic> json) {

    return HistoryModel(

      undoStack:
          List<Map<String, dynamic>>.from(
            json["undoStack"] ?? [],
          ),


      redoStack:
          List<Map<String, dynamic>>.from(
            json["redoStack"] ?? [],
          ),


      maxHistory:
          json["maxHistory"] ?? 100,


      enabled:
          json["enabled"] ?? true,

    );

  }

}