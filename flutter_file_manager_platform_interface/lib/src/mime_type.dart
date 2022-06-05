enum MimeType {
  avi('video/x-msvideo', 'avi'),
  bmp('image/bmp', 'bmp'),
  epub('application/epub+zip', 'epub'),
  gif('image/gif', 'gif'),
  json('application/json', 'json'),
  mpeg('video/mpeg', 'mpeg'),
  mp3('audio/mpeg', 'mp3'),
  otf('font/otf', 'otf'),
  png('image/png', 'png'),
  zip('application/zip', 'zip'),
  ttf('font/ttf', 'ttf'),
  rar('application/x-rar-compressed', 'rar'),
  jpeg('image/jpeg', 'jpeg'),
  aac('audio/aac', 'aac'),
  pdf('application/pdf', 'pdf'),
  opendocsheets('application/vnd.oasis.opendocument.spreadsheet', 'ods'),
  opendocpresentation('application/vnd.oasis.opendocument.presentation', 'odp'),
  opendoctext('application/vnd.oasis.opendocument.text', 'odt'),
  microsoftword(
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'docx',
  ),
  microsoftexcel(
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'xlsx',
  ),
  microsoftpresentation(
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'pptx',
  ),
  text('text/plain', 'txt'),
  csv('text/csv', 'csv'),
  asice('application/vnd.etsi.asic-e+zip', 'asice'),
  asics('application/vnd.etsi.asic-s+zip', 'asics'),
  bdoc('application/vnd.etsi.asic-e+zip', 'bdoc'),
  other('application/octet-stream', 'other');

  final String blobType;
  final String ext;

  const MimeType(this.blobType, this.ext);
}

extension ToMimeTypeExtension on String {
  MimeType toMimeType() => MimeType.values.firstWhere(
        (e) => e.ext == this,
        orElse: () => MimeType.other,
      );
}
