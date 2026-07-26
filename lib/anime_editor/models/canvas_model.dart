import 'canvas_settings_model.dart';
import 'layer_model.dart';

import 'ruler_model.dart';
import 'onion_skin_model.dart';
import 'selection_model.dart';
import 'paint_model.dart';
import 'eraser_model.dart';
import 'text_model.dart';
import 'image_model.dart';
import 'history_model.dart';
import 'clipboard_model.dart';
import 'duplicate_model.dart';
import 'layer_selection_model.dart';


class CanvasModel {

  CanvasSettingsModel settings;

  RulerModel ruler;

  OnionSkinModel onionSkin;

  SelectionModel selection;

  PaintModel paint;

  EraserModel eraser;

  TextModel text;

  ImageModel image;

  HistoryModel history;

  ClipboardModel clipboard;

  DuplicateModel duplicate;

  LayerSelectionModel layerSelection;


  List<LayerModel> layers;

  int selectedLayerIndex;


  CanvasModel({
    required this.settings,

    required this.ruler,
    required this.onionSkin,
    required this.selection,
    required this.paint,
    required this.eraser,
    required this.text,
    required this.image,
    required this.history,
    required this.clipboard,
    required this.duplicate,
    required this.layerSelection,

    required this.layers,

    this.selectedLayerIndex = 0,
  });



  /// Current selected layer
  LayerModel get currentLayer {

    if (layers.isEmpty) {
      throw Exception("No layers found.");
    }

    return layers[selectedLayerIndex];
  }



  /// Change selected layer
  void selectLayer(int index) {

    if (index < 0 || index >= layers.length) {
      return;
    }

    selectedLayerIndex = index;
  }



  Map<String, dynamic> toJson() {

    return {

      "settings": settings.toJson(),

      "ruler": ruler.toJson(),

      "onionSkin": onionSkin.toJson(),

      "selection": selection.toJson(),

      "paint": paint.toJson(),

      "eraser": eraser.toJson(),

      "text": text.toJson(),

      "image": image.toJson(),

      "history": history.toJson(),

      "clipboard": clipboard.toJson(),

      "duplicate": duplicate.toJson(),

      "layerSelection": layerSelection.toJson(),


      "layers":
          layers.map((layer) => layer.toJson()).toList(),


      "selectedLayerIndex": selectedLayerIndex,

    };
  }



  factory CanvasModel.fromJson(Map<String, dynamic> json) {

    return CanvasModel(

      settings:
    CanvasSettingsModel.fromJson(
      json["settings"] ?? {},
    ),


      ruler:
    RulerModel.fromJson(
      json["ruler"] ?? {},
    ),


    onionSkin:
    OnionSkinModel.fromJson(
      json["onionSkin"] ?? {},
    ),


      selection:
    SelectionModel.fromJson(
      json["selection"] ?? {},
    ),


      paint:
    PaintModel.fromJson(
      json["paint"] ?? {},
    ),


      eraser:
    EraserModel.fromJson(
      json["eraser"] ?? {},
    ),


      text:
    TextModel.fromJson(
      json["text"] ?? {},
    ),


      image:
    ImageModel.fromJson(
      json["image"] ?? {},
    ),

     history:
    HistoryModel.fromJson(
      json["history"] ?? {},
    ),


      clipboard:
    ClipboardModel.fromJson(
      json["clipboard"] ?? {},
    ),


      duplicate:
    DuplicateModel.fromJson(
      json["duplicate"] ?? {},
    ),


      layerSelection:
    LayerSelectionModel.fromJson(
      json["layerSelection"] ?? {},
    ),



      layers:
          (json["layers"] as List? ?? [])
              .map((e) => LayerModel.fromJson(e))
              .toList(),



      selectedLayerIndex:
          json["selectedLayerIndex"] ?? 0,

    );
  }

}