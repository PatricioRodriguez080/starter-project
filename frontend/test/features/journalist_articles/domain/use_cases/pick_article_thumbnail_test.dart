import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/use_cases/pick_article_thumbnail.dart';

void main() {
  test('returns a thumbnail that follows the thumbnail rules', () async {
    final dataState = await PickArticleThumbnailUseCase()();

    expect(dataState, isA<DataSuccess>());
    final thumbnail = dataState.data!;
    expect(thumbnail.bytes, isNotEmpty);
    expect(thumbnail.hasAllowedExtension, isTrue);
    expect(thumbnail.isWithinMaxSize, isTrue);
  });

  test('returns a real PNG image', () async {
    final thumbnail = (await PickArticleThumbnailUseCase()()).data!;

    const pngSignature = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    expect(thumbnail.bytes.take(8), pngSignature);
  });
}
