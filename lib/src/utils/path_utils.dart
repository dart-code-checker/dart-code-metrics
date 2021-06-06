import 'dart:io';

String? uriToPath(Uri? uri) {
  if (uri == null) {
    return null;
  }

  if (uri.scheme == 'file') {
    return uri.toFilePath();
  }

  return File(uri.path).absolute.path;
}
