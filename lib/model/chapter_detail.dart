class ChapterDetail {
    List<String> lstImage;
    int chapterNumber;

    ChapterDetail({
        required this.lstImage,
        required this.chapterNumber,
    });
  factory ChapterDetail.fromJson(Map <String, dynamic> data) {
  // Ép kiểu sang List<Dynamic> trước khi map sang List<String>, vì data['lstImage'] có kiểu là dynamic
  // Nên cần ép kiểu để tránh lỗi, sau đó map từng phần tử sang String và chuyển thành List<String>
  // e trước khi ép kiểu là dynamic nên cần ép kiểu sang String
    final lstImage = (data['lstImage'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [];
    final chapterNumber = data['chapterNumber'] as int? ?? 0;
    
    return ChapterDetail(
      lstImage: lstImage, 
      chapterNumber: chapterNumber
    );
  }
}
