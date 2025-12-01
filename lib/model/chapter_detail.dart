class ChapterDetail {
    List<String> lstImage;
    int chapterNumber;

    ChapterDetail({
        required this.lstImage,
        required this.chapterNumber,
    });
  factory ChapterDetail.fromJson(Map <String, dynamic> data) {
    final lstImage = (data['lstImage'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [];
    final chapterNumber = data['chapterNumber'] as int? ?? 0;
    
    return ChapterDetail(
      lstImage: lstImage, 
      chapterNumber: chapterNumber
    );
  }
}
