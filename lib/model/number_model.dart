class NumberModel {
    int totalChapters;
    List<String> chapters;

    NumberModel({
        required this.totalChapters,
        required this.chapters,
    });
    factory NumberModel.fromJson(Map <String, dynamic> data) {
      final totalChapters = data['totalChapters'] as int? ?? 0;
      final chapters = (data['chapters'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [];

      return NumberModel(
        totalChapters: totalChapters,
        chapters: chapters,
      );
    }
  }

