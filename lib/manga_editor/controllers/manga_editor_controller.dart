class MangaEditorController {

  String projectName;
  String size;
  int pages;


  MangaEditorController({
    required this.projectName,
    required this.size,
    required this.pages,
  });


  Map<String, dynamic> saveProject() {
    return {
      "name": projectName,
      "type": "manga",
      "size": size,
      "pages": pages,
    };
  }


  void addPages(int value) {
    pages += value;
  }


  void reset() {
    pages = 1;
  }
}