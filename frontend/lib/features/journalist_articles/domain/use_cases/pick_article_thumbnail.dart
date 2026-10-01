import 'dart:convert';

import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/article_thumbnail.dart';

class PickArticleThumbnailUseCase
    implements UseCase<DataState<ArticleThumbnailEntity?>, void> {
  // TODO(2.3): replace the mock image with ArticleThumbnailRepository.pickThumbnailFromGallery().
  @override
  Future<DataState<ArticleThumbnailEntity?>> call({void params}) async {
    return DataSuccess(
      ArticleThumbnailEntity(
        bytes: base64Decode(_mockThumbnailPngInBase64),
        fileExtension: 'png',
      ),
    );
  }
}

// 64x36 PNG with a purple to blue gradient.
const String _mockThumbnailPngInBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAEAAAAAkCAIAAAC2bqvFAAABsUlEQVR42tXPaS8CABwH4P8XYowxkjMkJEdCkgghIUIyhjGGMcYw'
    'xhjGGOZI7vu+7/u+79tbfY3fN3geSjPo1Rj2aYz6Uo371SZatak2xWwg2VyXbKFLshxUMYZUzKFE6+EE2xGl3ajSYTSeNRbnOB7n'
    'PB7LnlBwJhWukzHuU3LutJw3He05E+U1G+UzG8mfkwnmZX7zEQEL4cLFcNFiWNCSVLwslSyHhqyESFclYWuSiLVg2bo4ckMcvREk'
    '3xQptkSxW4Hx20LljjBxJ0C165+055+y56feF2gOBGkHvumH/IwjfuaRT9axd/aJd86JV+6pZ94ZQet5+ecErecVnBO03qPwgqD1'
    '3KJLgtZziy8JWu9eckXQerfSa4LWu5VdE7TetfyGoPWciluC1nMqbwla71J1R9B6dvU9QevZNfoAst659oGg9U51jwStd6rXB5D1'
    'jg1PBK1nNT4TtJ7VpA8g6x2aXwhab9/yStB6+1Z9AFlv1/ZG0Hrb9neC1tt0fBC03qbzg6D11l2fBK1ndn8RtJ7Z80XQeqveb4LW'
    'M/p/CFrP0P4QtN5S90vQeovBv38UtcDddFuQsAAAAABJRU5ErkJggg==';
